permissionset 50900 "All"
{
    Access = Internal;
    Assignable = true;
    Caption = 'All permissions', Locked = true;

    Permissions =
         page "eCDF Rules" = X,
         page "eCDF Statement" = X,
         page "eCDF Statement List" = X,
         report "Create eCDF Statement" = X,
         report "Check VAT Statement" = X,
         report "Create XML File" = X,
         table "eCDF Data" = X,
         table "eCDF Rules" = X,
         tabledata "eCDF Data" = RIMD,
         tabledata "eCDF Rules" = RIMD;
}