param ( 
      $command , $param 
) 

function list { 
    [xml]$xml = Get-Content /Users/zakky555/Desktop/powershell-learning/public/todo.list.xml
#    Write-Output "Select List Function"
    foreach ($task in $xml.todo.task){
          Write-Output $task
    }
} 

function add {
    [xml]$xml = Get-Content /Users/zakky555/Desktop/powershell-learning/public/todo.list.xml

#    Write-Output "Select Add Function" 
    $newnode  = $xml.CreateElement('task')
    $newNode.InnerText = $param 
    $xml.todo.AppendChild($newNode)
    $xml.Save('/Users/zakky555/Desktop/powershell-learning/public/todo.list.xml')
    list
} 

function done { 
    Write-Output "Select Done Function" 
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
        "Invalid Command" 
        } 
     } 

} 

selectcommand
