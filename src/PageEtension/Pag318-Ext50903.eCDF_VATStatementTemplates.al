/// <summary>
/// PageExtension VAT Statement Templates_Ext (ID 50903) extends Record VAT Statement Templates.
/// </summary>
pageextension 50903 "VAT Statement Templates" extends "VAT Statement Templates"
{
    Caption = 'VAT Statement Templates';

    actions
    {
        modify("Statement Names")
        {
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;
        }
    }
}