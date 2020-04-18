function selectQuery($connectionString, $sql)
{
    # Build SQL connection
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $command = $connection.CreateCommand()
    $command.CommandText = $sql
    $command.CommandTimeout = 0
    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet

    # Query SQL server
    $connection.Open()
    $adapter.Fill($dataset) | out-null
    $connection.Close()

    # Return Data
    $dataset.Tables[0]

}

function selectQueryTable($connectionString, $sql)
{
    # Build SQL connection
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $command = $connection.CreateCommand()
    $command.CommandText = $sql
    $command.CommandTimeout = 0
    $adapter = New-Object System.Data.SqlClient.SqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet

    # Query SQL server
    $connection.Open()
    $adapter.Fill($dataset) | out-null
    $connection.Close()

    # Return Data
    return $dataset

}

function executeStoredProcedure($connection, $query)
{
    
    $sqlConnection = new-object System.Data.SqlClient.SqlConnection $connection
    $sqlConnection.Open() 
     
    $sqlCmd = new-object System.Data.SqlClient.SqlCommand($query, $sqlConnection)
    $sqlCmd.CommandTimeout = 300
 
    $sqlCmd.Parameters.Add("@ReturnValue", [System.Data.SqlDbType]"Int") 
    $sqlCmd.Parameters["@ReturnValue"].Direction = [System.Data.ParameterDirection]"ReturnValue"
 
    $sqlCmd.ExecuteNonQuery() | out-null
    $sqlConnection.Close() 
 
    [int]$sqlCmd.Parameters["@ReturnValue"].Value
     
}

function getDataStoredProcedure($connection, $storedProcedure, $param1, $param1Value)
{
    #SQL Connection - connection to SQL server
    $sqlConnection = new-object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = $connection
 
    #SQL Command - set up the SQL call
    $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $sqlCommand.Connection = $sqlConnection
    $sqlCommand.CommandText = "$storedProcedure $param1"
    $sqlCommand.Parameters.AddWithValue($param1,$param1Value) | out-null
    $sqlCommand.Parameters.Add("@ReturnValue", [System.Data.SqlDbType]"Int") | out-null
    $sqlCommand.Parameters["@ReturnValue"].Direction = [System.Data.ParameterDirection]"ReturnValue"
 
    #Open SQL Connection
    $sqlConnection.Open();
    
    #SQL Adapter - get the results using the SQL Command
    $sqlAdapter = new-object System.Data.SqlClient.SqlDataAdapter 
    $sqlAdapter.SelectCommand = $sqlCommand
    $dataSet = new-object System.Data.Dataset
    try{$recordCount = $sqlAdapter.Fill($dataSet) }
    catch{write-host "Not able to execute getDataStoredProcedure VARIABLES; $connection $storedProcedure $param1 $param1Value"}
 
    #Close SQL Connection
    $sqlConnection.Close();
 
    #Get single table from dataset
    if([int]$sqlCommand.Parameters["@ReturnValue"].Value -eq 0){$dataSet.Tables[0]}
    else{write-host "Stored Procedure Failed, Return Code not 0  VARIABLES; $connection $storedProcedure $param1 $param1Value"}
}

function getDataStoredProcedureTable($connection, $storedProcedure)
{
    #SQL Connection - connection to SQL server
    $sqlConnection = new-object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = $connection
 
    #SQL Command - set up the SQL call
    $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $sqlCommand.Connection = $sqlConnection
    $sqlCommand.CommandText = "$storedProcedure"
    $sqlCommand.Parameters.Add("@ReturnValue", [System.Data.SqlDbType]"Int") | out-null
    $sqlCommand.Parameters["@ReturnValue"].Direction = [System.Data.ParameterDirection]"ReturnValue"
 
    #Open SQL Connection
    $sqlConnection.Open();
    
    #SQL Adapter - get the results using the SQL Command
    $sqlAdapter = new-object System.Data.SqlClient.SqlDataAdapter 
    $sqlAdapter.SelectCommand = $sqlCommand
    $dataSet = new-object System.Data.Dataset
    try{$recordCount = $sqlAdapter.Fill($dataSet) }
    catch{write-host "Not able to execute getDataStoredProcedure VARIABLES; $connection $storedProcedure"}
 
    #Close SQL Connection
    $sqlConnection.Close();
 
    #Get single table from dataset
    if([int]$sqlCommand.Parameters["@ReturnValue"].Value -eq 0){$dataSet}
    else{write-host "Stored Procedure Failed, Return Code not 0  VARIABLES; $connection $storedProcedure"}
}

function BulkCopy($connectionString, $table, $data)
{
    # Build SQL connection
    $connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
    $bulkCopy = New-Object System.Data.SqlClient.SqlBulkCopy($connection)
    $bulkCopy.DestinationTableName = $table

    # Bulk Copy to SQL server
    $connection.Open()
    $bulkCopy.WriteToServer($data) | out-null
    $connection.Close()

    # Return
    return 0
}