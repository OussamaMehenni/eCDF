/// <summary>
/// PageExtension VAT Business Posting Groups (ID 50906) extends Record VAT Business Posting Groups.
/// </summary>
pageextension 50906 "VAT Business Posting Groups" extends "VAT Business Posting Groups"
{
    Caption = 'VAT Business Posting Groups';
    layout
    {
        addafter(Description)
        {
            field("VAT Region"; rec."VAT Region")
            {
                ApplicationArea = All;
                Tooltip = 'Specifies the VAT Partner Region';
            }

        }
    }
}