unit smartpointform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Ingeo_TLB, InScripting_TLB, M2Addon, ComCtrls;

type
  TfSmartPointMaker = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    eSelStyle: TEdit;
    Button1: TButton;
    cbDeleteOld: TCheckBox;
    eFormat: TEdit;
    Button2: TButton;
    cbField: TComboBox;
    cbNoRepeat: TCheckBox;
    eStartN: TEdit;
    Label5: TLabel;
    cbTextStyle: TComboBox;
    Label6: TLabel;
    eDX: TEdit;
    Label7: TLabel;
    eDY: TEdit;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    pstyle,tstyle:string;
    tstyles:array of string;
    procedure Loadfields;
    procedure LoadStyles;
    procedure MakePoints;
    { Private declarations }
  public
    app:IIngeoApplication;
    { Public declarations }
  end;

var
  fSmartPointMaker: TfSmartPointMaker;

implementation
uses selstyle, smartpointmaker;
{$R *.dfm}

procedure TfSmartPointMaker.Button1Click(Sender: TObject);
var f:TfSelectStyle;
begin
  f:=TfSelectStyle.Create(nil);
  if f.ShowModal=mrOk then
  begin
    pstyle:=PM2ID(f.trv1.Selected.Data)^;
    eSelStyle.Text:=f.trv1.Selected.Text;
    LoadFields;
    LoadStyles;
  end;
  f.Free;
end;

procedure TfSmartPointMaker.Button2Click(Sender: TObject);
begin
  MakePoints;
end;

procedure TfSmartPointMaker.Loadfields;
var st:IIngeoSemTables;
    i,t:integer;
    sst:IIngeoSemTable;
    fn:string;
begin
  cbField.Items.Clear;
  st:=app.ActiveDb.StyleFromID(pstyle).Layer.SemTables;
  for i:=0 to st.Count-1 do
  begin
    sst:=st.Item[i];
    for t:=0 to sst.FieldInfos.Count-1 do
    begin
      fn:=sst.Name+'.'+sst.FieldInfos.Item[t].FieldName;
      cbField.Items.Add(fn);
    end;
  end;
end;

procedure TfSmartPointMaker.LoadStyles;
var
  lar: IIngeoLayer;
  i: Integer;
begin
 lar:=app.ActiveDb.StyleFromID(pstyle).Layer;
 SetLength(tstyles,lar.Styles.Count);
 for i := 0 to lar.Styles.Count - 1 do
 begin
   cbTextStyle.Items.Add(lar.Styles[i].Name);
   tstyles[i]:=lar.Styles[i].ID;
 end;

end;

procedure TfSmartPointMaker.MakePoints;
var tm:TSmartPointMaker;
    dx,dy:double;
    strtn:integer;

begin
  dx:=1;dy:=1;
  TryStrToFloat(eDX.Text,dx);
  TryStrToFloat(eDY.Text,dx);
  strtn:=1;
  TryStrToInt(eStartN.Text,strtn);
  if cbTextStyle.ItemIndex=-1 then
  begin
    ShowMessage('Не выбран стиль подписей!');
    exit;
  end;
  tstyle:=tstyles[cbTextStyle.ItemIndex];
  tm:=TSmartPointMaker.Create(app,pstyle,tstyle,cbField.Text,
     dx,dy, eFormat.Text,strtn,cbDeleteOld.Checked,cbNoRepeat.Checked);
  tm.progress:=ProgressBar1;
  tm.MakePoints;
  tm.Free;

end;

end.
