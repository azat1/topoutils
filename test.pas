unit test;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfTest = class(TForm)
    cbMContains: TCheckBox;
    cbMContained: TCheckBox;
    cbMIntersected: TCheckBox;
    Label1: TLabel;
    cbContains: TCheckBox;
    cbContained: TCheckBox;
    cbIntersected: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    cbMTouched: TCheckBox;
    cbTouched: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    selobj:string;
    { Private declarations }
  public

    { Public declarations }
  end;

var
  fTest: TfTest;

implementation
uses selstyle, M2Addon,M2AddonD,Ingeo_TLB, addn;
{$R *.dfm}

procedure TfTest.Button1Click(Sender: TObject);
var f:TfSelectStyle;
begin
//
  f:=TfSelectStyle.Create(self);
  if f.ShowModal=mrOk then
  begin
    Edit1.Text:=PM2ID(f.trv1.Selected.Data)^;
  end;
end;

procedure TfTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfTest.Button2Click(Sender: TObject);
var mq:IIngeoMapObjectsQuery;
    rel,relm,spi:integer;
    slar,cobj:string;
    larid,objid:widestring;
begin
  rel:=0; relm:=0;
  slar:=gAddon2.ActiveDb.StyleFromID(Edit1.Text).Layer.ID;
  cobj:=selobj;
  if cbMContains.Checked then relm:=relm or incrContains;
  if cbMContained.Checked then relm:=relm or incrContained;
  if cbMIntersected.Checked then relm:=relm or incrIntersected;
  if cbMTouched.Checked then relm:=relm or incrTouched;

  if cbContains.Checked then rel:=rel or incrContains;
  if cbContained.Checked then rel:=rel or incrContained;
  if cbIntersected.Checked then rel:=rel or incrIntersected;
  if cbTouched.Checked then rel:=rel or incrTouched;
  mq:=gAddon2.ActiveDb.MapObjects.QueryByObject(slar,cobj,relm,rel);
  gAddon2.Selection.DeselectAll;
  if mq.EOF then ShowMessage('Нет объектов!');
  while not mq.EOF do
  begin
    mq.Fetch(larid,objid,spi);
    gAddon2.Selection.Select(objid,-1);
  end;
end;

procedure TfTest.FormCreate(Sender: TObject);
begin
  //
  if gAddon2.Selection.Count=0 then exit;
  selobj:=gAddon2.Selection.IDs[0];
end;

end.
