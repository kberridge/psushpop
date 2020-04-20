# PowerShell PushPop - a mental stack manager
# Inspired by http://www.secretgeek.net/pushpop and https://paste.sr.ht/~erazemkokot/c6aeb2a7bc25049d08825b3cc7aea63b5cf72a08
# The stack file is in reverse order (file bottom = stack top)

$Settings = @{
  Stack = "~/.psushpop.txt"
  History = "~/.psushpop-history.txt"
}

<#
.SYNOPSIS
Push a task onto the stack
.PARAMETER Task
The task to add
#>
function Push-PPTask(
  [Parameter(Position=0,
    Mandatory=$true,
    ValueFromPipeline=$true)]
  [string[]]$Task
) {
  $Task | out-file $Settings.Stack -Append
}
Export-ModuleMember -Function Push-PPTask

<#
.SYNOPSIS
Get the current task on the stack
.PARAMETER Snoop
Get all tasks
#>
function Get-PPTask([switch]$Snoop) {
  if(!$Snoop) {
    Get-Content $Settings.Stack -Tail 1
  }
  else {
    $tasks = @(Get-Content $Settings.Stack)
    if ($tasks) {
      [array]::Reverse($tasks)
      $tasks
    }
  }
}
Export-ModuleMember -Function Get-PPTask

<#
.SYNOPSIS
Take the current task off the stack, store it in history
#>
function Pop-PPTask {
  Get-PPTask | out-file $Settings.History -Append
  $lines = @(Get-Content $Settings.Stack)
  if ($lines.Count -lt 2) {
    clear-content $Settings.Stack
  }
  else {
    $lines[0..($lines.Count-2)] | out-file $Settings.Stack 
  }
}
Export-ModuleMember -Function Pop-PPTask

<#
.SYNOPSIS
Get history of all popped tasks
#>
function Get-PPTaskHistory {
  Get-Content $Settings.History
}
Export-ModuleMember -Function Get-PPTaskHistory