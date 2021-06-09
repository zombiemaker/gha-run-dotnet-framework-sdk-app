$path = "c:\users\containeradministrator\documents"
$newAcl = get-acl -path $path
# Set properties
$identity = "BUILTIN\Users"
$fileSystemRights = "FullControl"
$type = "Allow"
$isProtected = $false
$preserveInheritance = $false
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = new-object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$newAcl.SetAccessRule($fileSystemAccessRule)
$newAcl.SetAccessRuleProtection($isProtected, $preserveInheritance)
set-acl -path $path -AclObject $newAcl