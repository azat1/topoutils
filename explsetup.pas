unit explsetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ImgList, ToolWin, StdCtrls;

type
  TfExplicationSetup = class(TForm)
    Button1: TButton;
    Button2: TButton;
    tvM: TTreeView;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
  private
    procedure LoadSettings;
    procedure SaveSettings;
    procedure AddGroup;
    procedure AddStyles;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fExplicationSetup: TfExplicationSetup;

implementation
uses mselstyle,ADDN, m2addon,m2addond,frm;
{$R *.dfm}

procedure TfExplicationSetup.AddGroup;
var n:TTreeNode;
begin
  tvM.Items.Add(nil,'Новая группа');
end;

procedure TfExplicationSetup.AddStyles;
var gn,sn:TTreeNode;
    ps:PM2ID;
    ms:TfMSelectStyle;
    stllist:TStringList;
    i:integer;
    stlname:string;
begin
  if tvM.Selected<>nil then
  begin
    if tvM.Selected.Level=1 then
      gn:=tvM.Selected.Parent else
      gn:=tvM.Selected;
    stllist:=TStringList.Create;
    ms:=TfMSelectStyle.Create(self,stllist);
    if ms.ShowModal=mrCancel then exit;
    ms.Free;
    for i:=0 to stllist.Count-1 do
    begin
      stlname:= gAddon2.ActiveDb.StyleFromID(stllist.Strings[i]).Layer.Name+'\'+gAddon2.aCTIVEdB.StyleFromID(stllist.Strings[i]).Name;
//                gAddon2.ActiveDb.StyleFromID(stllist.Strings[i]).Layer.Name;
      new(ps);
      ps^:=stllist.Strings[i];
      sn:=tvM.Items.AddChild(gn,stlname);
      sn.Data:=ps;
    end;
  end;
end;

procedure TfExplicationSetup.LoadSettings;
var i,j:integer;
    g,s:TTreeNode;
    ps:PM2ID;
    sname,stl:string;
begin
  for i:=0 to MainForm.explgroups.count-1 do
  begin
    g:=tvM.Items.Add(nil,MainForm.explgroups.items[i].name);
    for j:=0 to MainForm.explgroups.items[i].count-1 do
    begin
      New(ps);
      ps^:=MainForm.Explgroups.items[i].ids[j];
      sname:=Gaddon2.ActiveDb.StyleFromID(ps^).Layer.Name+'\'+
        Gaddon2.ActiveDb.StyleFromID(ps^).Name;
      s:=tvM.Items.AddChild(g,sname);
      s.Data:=ps;
    end;
  end;
end;

procedure TfExplicationSetup.SaveSettings;
var i,j:integer;
    g,s:TTreeNode;
    ps:PM2ID;
    sname,stl:string;
begin
//  tvM.Items.
  MainForm.explgroups.count:=0;
  for i:=0 to tvM.Items.count-1 do
  begin

    if tvM.Items.Item[i].Level=0 then
    begin
      MainForm.explgroups.items[MainForm.explgroups.count].name:=tvM.Items.Item[i].Text;
      MainForm.explgroups.items[MainForm.explgroups.count].count:=tvM.Items.Item[i].Count;
      for j:=0 to MainForm.explgroups.items[MainForm.explgroups.count].count-1 do
      begin
        MainForm.Explgroups.items[MainForm.explgroups.count].ids[j]:=PM2ID(tvM.Items.Item[i].Item[j].Data)^;
      end;
      inc(MainForm.explgroups.count);
    end;
  end;
end;

procedure TfExplicationSetup.ToolButton1Click(Sender: TObject);
begin
  AddGroup;
end;

procedure TfExplicationSetup.ToolButton2Click(Sender: TObject);
begin
  AddStyles;
end;

procedure TfExplicationSetup.FormShow(Sender: TObject);
begin
  LoadSettings;
end;

procedure TfExplicationSetup.Button1Click(Sender: TObject);
begin
  SaveSettings;
end;

procedure TfExplicationSetup.ToolButton3Click(Sender: TObject);
begin
  tvM.Items.Delete(tvM.Selected);
end;

procedure TfExplicationSetup.ToolButton6Click(Sender: TObject);
begin
  if MessageDlg('Удалить все ?',mtWarning,[mbYes,mbNo],0)=mrYes then
  begin
    tvM.Items.Clear;
  end;
end;

end.
