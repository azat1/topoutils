unit objselectform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, DllForm, Ingeo_TLB, InScripting_TLB;

type
  TfObjectSelect = class(TM2AddonForm)
    Label1: TLabel;
    clbStyles: TCheckListBox;
    Label2: TLabel;
    cbPerimeterOp: TComboBox;
    ePerim1: TEdit;
    ePerim2: TEdit;
    Label3: TLabel;
    cbSquareOp: TComboBox;
    eSquare1: TEdit;
    eSquare2: TEdit;
    Label4: TLabel;
    cbFieldOp: TComboBox;
    cbField: TComboBox;
    cbFieldValue: TComboBox;
    Button1: TButton;
    cbField2: TComboBox;
    cbFieldOp2: TComboBox;
    cbFieldValue2: TComboBox;
    Label5: TLabel;
    cbRange: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     stls: TStringList;

    { Private declarations }
    procedure LoadStyles;
    procedure LoadFields;
    procedure SelectObjectByLength;
  public
    app:IIngeoApplication;
    { Public declarations }
  end;

var
  fObjectSelect: TfObjectSelect;

procedure StartObjSelect(app:IIngeoApplication);

implementation
uses objselector;
{$R *.dfm}

procedure StartObjSelect(app:IIngeoApplication);
var f:TfObjectSelect;
begin
  f:=TfObjectSelect.Create(nil);
  f.app:=app;
  f.Show;

end;

procedure TfObjectSelect.Button1Click(Sender: TObject);
var z:double;
begin
  if TryStrToFloat(ePerim1.Text, z) then
    SelectObjectByLength();
end;

procedure TfObjectSelect.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfObjectSelect.FormShow(Sender: TObject);
begin
  LoadStyles;
  LoadFields;
end;

procedure TfObjectSelect.LoadFields;
begin

end;

procedure TfObjectSelect.LoadStyles;
var lar:IIngeoLayer;
  i: Integer;
begin

   stls:=TStringList.Create;
   clbStyles.Items.Clear;
   try
     lar:=app.ActiveProjectView.ActiveLayerView.Layer;//.SelectedLayerView.Layer;
   except
     exit;
   end;
//   if lar. then

   for i := 0 to lar.Styles.Count - 1 do
   begin
     clbStyles.Items.Add(lar.Styles.Item[i].Name);
     stls.Add(lar.Styles.Item[i].ID);
   end;
end;

procedure TfObjectSelect.SelectObjectByLength;
var l1,l2:double;
  selector: TObjectSelector;
begin
  if TryStrToFloat(ePerim1.Text,l1) and TryStrToFloat(ePerim2.Text,l2) then
  begin
    selector:=TObjectSelector.Create(app);
    selector.SelectObjectsByLength(l1,l2);
    selector.Free;
  end;
end;

end.
