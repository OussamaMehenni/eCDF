/// <summary>
/// Codeunit eCDF Subscribers (ID 50900).
/// </summary>
codeunit 50900 "eCDF Subscribers"
{
    trigger OnRun()
    begin
    end;

    /// <summary>
    /// Table_254_OnBeforeInsertEvent.
    /// </summary>
    /// <param name="Rec">VAR Record 254.</param>
    /// <param name="RunTrigger">Boolean.</param>
    [EventSubscriber(ObjectType::Table, 254, 'OnBeforeInsertEvent', '', false, false)]
    procedure Table_254_OnBeforeInsertEvent(var Rec: Record 254; RunTrigger: Boolean)
    var
        VATPostingSetup: Record 325;
    begin
        IF VATPostingSetup.GET(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") THEN BEGIN
            Rec.VALIDATE("EU Goods", VATPostingSetup."EU Goods");
        END;
    end;

    /// <summary>
    /// Table_255_OnBeforeDeleteEvent.
    /// </summary>
    /// <param name="Rec">VAR Record 255.</param>
    /// <param name="RunTrigger">Boolean.</param>
    [EventSubscriber(ObjectType::Table, 255, 'OnBeforeDeleteEvent', '', false, false)]
    procedure Table_255_OnBeforeDeleteEvent(var Rec: Record 255; RunTrigger: Boolean)
    var
        LuxembourgVATData: Record "eCDF Data";
    begin
        Clear(LuxembourgVATData);
        LuxembourgVATData.SetRange("Statement Template Name", Rec.Name);
        if (LuxembourgVATData.FINDSET(FALSE, FALSE)) then
            ERROR(TextStatementExists);
    end;

    /// <summary>
    /// Table_257_OnBeforeDeleteEvent.
    /// </summary>
    /// <param name="Rec">VAR Record 257.</param>
    /// <param name="RunTrigger">Boolean.</param>
    [EventSubscriber(ObjectType::Table, 257, 'OnBeforeDeleteEvent', '', false, false)]
    procedure Table_257_OnBeforeDeleteEvent(var Rec: Record 257; RunTrigger: Boolean)
    var
        LuxembourgVATData: Record "eCDF Data";
    begin
        Clear(LuxembourgVATData);
        LuxembourgVATData.SetRange("Statement Template Name", Rec.Name);
        LuxembourgVATData.SetRange("Statement Name", Rec.Name);
        if (LuxembourgVATData.FINDSET(FALSE, FALSE)) then
            ERROR(TextStatementExists);
    end;

    var
        TextStatementExists: Label 'eCDF Statement(s) exists!';
}
