param ( 
      $command , $param 
)

$filename = "$pwd\public\todo.list.xml"

function list { 
    $i = 0
    [xml]$xml = (Get-Content $filename)
#    Write-Output "Select List Function"
    foreach ($task in $xml.todo.task){
          #Write-Host ("["+$i +"] " + $task)
          Write-Output ("["+$i +"] " + $task)
          $i++
    }
    

} 

function add {
    
    
    [xml]$xml = (Get-Content $filename) 
    $newnode  = $xml.CreateElement('task')
    $newNode.InnerXml = $param 
    $xml.todo.AppendChild($newNode)
    $xml.Save($filename)
    list
} 

function done { 
    [xml]$xml = (Get-Content $filename)
    $row = $xml.SelectNodes("/todo/task")
    #$row.count
    if($param -In 0..($row.Count-1)){
    $nodedelete = $xml.todo.ChildNodes.item($param)
    $xml.todo.RemoveChild($nodedelete)
    $xml.Save($filename)
    list
    }
    else {"Invalid Parameter Please Insert Task Number that you have done."}
    

} 

function selectcommand { 
     switch ($command) 
     { 
        'list'{ 
        list 
        } 
        'add'{ 
        add 
        } 
        'done'{ 
        done 
        } 
        default{ 
        "Invalid Command : Command Should be (list|add|done)" 
        } 
     } 

} 

selectcommand
