param ( 
      $command , $param 
)

function Get-Content-from-XML ($filename) {
# Function for Load XML file.
     [xml]$xml = (Get-Content $filename)
     return $xml
}

function list { 
# Function for List Task that read from XML File
    $i = 0
    #$xml = Get-Content-from-XML($filename)
    $list =""
    foreach ($task in $xml.todo.task){
          $list = $list+ "["+$i +"] " + $task +"`n"
          $i++
    }
    return $list

} 

function add {
#Function for Add Task with user input task. the latest Task will be added last of list.
    if($param -ne $null){
    $newnode  = $xml.CreateElement('task')
    $newNode.InnerXml = $param 
    $xml.todo.AppendChild($newNode)
    }
    return $xml

} 

function done  {
#function for Remove Task that you have done. By input Task Number.
    $row = $xml.SelectNodes("/todo/task")
    if($param -In 0..($row.Count-1)){
    $nodedelete = $xml.todo.ChildNodes.item($param)
    #$xml.todo.ChildNodes.item($param)
    $xml.todo.RemoveChild($nodedelete)
    return $xml
    }
    # Script will be Break When you input invalid Task number
    else {
    "Invalid Task Number. Please Insert Task Number that you have done."
    Break Script
    }
    

} 

function selectcommand ($command) {
# function for select command from User input Parameter.
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


#Main Funtions
$filename = "$pwd\public\todo.list.xml"
$xml = Get-Content-from-XML($filename)
selectcommand ($command)
$xml.Save($filename)
if(($command -eq "add") -or ($command -eq "done"))
{list}




#Powershell Pester Test
Describe 'selectcommand'{
$filename = "$pwd\public\todo.list.test.xml"
It "outputs invalid command msg when input wrong command" {
        if (($command -ne "list") -and ($command -ne "add") -and ($command -ne "done") ){
            selectcommand $command | Should Be 'Invalid Command : Command Should be (list|add|done)'
        }
}
}


Describe 'list' {
     $filename = "$pwd\public\todo.list.test.xml"
     It "Show The Latest Task Lists."{
     $xml = Get-Content-from-XML($filename)
     $i=0
     $expect=""
          foreach ($expect_test in $xml.todo.task){
            $expect = $expect + "["+$i+"] " +$expect_test +"`n"
           
            $i++
          }
      list | Should Be $expect
          }
}


Describe 'add' {
      $filename = "$pwd\public\todo.list.test.xml"
      $param = "I will be the best DevOps"
      It "Show Latest Task after Add Task" {
          $array = @()
          if(($param -ne $null)-and($command -eq 'add')){      
             add $param
             #$xml_test = Get-Content-from-XML($filename)
             foreach ($task_test in $xml.todo.task){
                   $array+= $task_test
             }
             $row = $xml.SelectNodes("/todo/task")
             $lastindex = $row.Count  - 1
             $actual = $array[$lastindex]  
             $actual | Should Be $param 
          }
      }
      It "did not add Task When you input Task with Null"{
          $actual = @()
          $expect = @()
          if($param -eq $null){
              $xml_test = Get-Content-from-XML($filename)
              foreach ($expect_test in $xml_test.todo.task){
                   $expect+= $expect_test
              }
              add $param
              foreach ($actual_test in $xml.todo.task){
                   $actual+= $actual_test
              }
              $actual_row = $xml.SelectNodes("/todo/task")
              $expect_row = $xml_test.SelectNodes("/todo/task")
              $actual[$actual_row.Count-1] | Should be $expect[$expect_row.Count-1]

          }
          }
}

Describe 'done' {
      $filename = "$pwd\public\todo.list.test.xml"
      $param = 3
     It "Show Invalid Done Parameter" {
          $xml = Get-Content-from-XML($filename)
          $row = $xml.SelectNodes("/todo/task")
          if(-Not($param -In 0..($row.Count-1))){
                 done $param | Should be "Invalid Parameter Please Insert Task Number that you have done."
          }
     }
     It "remove task when you input right task number."{
         $expect = @()
         $actual = @()
         $xml = Get-Content-from-XML($filename)
         $row = $xml.SelectNodes("/todo/task")
         if($param -In 0..($row.Count-1)){
            foreach ($expect_test in $xml.todo.task){
                $expect+= $expect_test
            }
            done $param
            foreach ($actual_test in $xml.todo.task){
                $actual+= $actual_test
            }
            $actual[$param] | should not be $expect[$param]
         }  
     }
}