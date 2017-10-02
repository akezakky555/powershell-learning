$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"
 
Describe "list-task" {
    It "outputs 'Hello world!'" {
        list-task | Should Be 'Hello world!'
    }
}
