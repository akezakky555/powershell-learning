param ( 
      $command 
) 

function list { 
    Write-Output "Select List Function" 
} 

function add { 
    Write-Output "Select Add Function" 
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
