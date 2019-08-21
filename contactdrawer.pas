unit contactdrawer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,dllform, ingeo_tlb, InScripting_TLB, cdmedit;
const
  paramprefix='contactdrawer';
type
  TfContactDrawer = class(TM2AddonForm)
    Label1: TLabel;
    eos: TEdit;
    Button1: TButton;
    Label2: TLabel;
    eStyle: TEdit;
    Button2: TButton;
    cbActive: TCheckBox;
    procedure cbActiveClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    selstyle:string;
    editor:TCDPointSelector;
    procedure LoadParams;
    procedure SaveParams;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fContactDrawer: TfContactDrawer;

implementation
uses addn, selstyle;
{$R *.dfm}

procedure TfContactDrawer.Button1Click(Sender: TObject);
begin
  if gaddon2.Selection.Count=0 then
  begin
    Showmessage('Не выбран объект!');
    exit;
  end;
  eos.Text:=gaddon2.Selection.IDs[0];
  editor.LoadOS(eos.Text);
end;

procedure TfContactDrawer.Button2Click(Sender: TObject);
var f:TfSelectStyle;
begin
  f:=TfSelectStyle.Create(self);
  if f.ShowModal=mrok then
  begin
    selstyle:=f.selstyle;
    eStyle.Text:=GetStyleName(selstyle);
    editor.objstyle:=selstyle;
  end;
end;

procedure TfContactDrawer.cbActiveClick(Sender: TObject);
begin
  editor.Active:=cbActive.Checked;
end;

procedure TfContactDrawer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveParams;
  GAddon.MapView.RemoveEditor(editor.IEditor);
  editor.Free;
  editor:=nil;
end;

procedure TfContactDrawer.FormShow(Sender: TObject);
begin
  LoadParams;
  editor:=TCDPointSelector.Create(gAddon);
  gAddon.MapView.AddEditor(editor.IEditor);
  editor.objstyle:=selstyle;
end;

procedure TfContactDrawer.LoadParams;
begin
  selstyle:=gAddon2.UserProfile.Get(inupUser,'',paramprefix+'SELSTL','');
  if gAddon2.ActiveDb.StyleExists(selstyle) then
  begin
    eStyle.Text:=GetStyleName(selstyle);
  end;
  
end;

procedure TfContactDrawer.SaveParams;
begin
  gAddon2.UserProfile.Put(inupUser,'',paramprefix+'SELSTL',selstyle);

end;

end.
