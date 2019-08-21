unit thmaker;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ComCtrls, ToolWin, M2Addon,M2AddonD,DllForm, thclass;

type
  TfTHMaker = class(TM2AddonForm)
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ImageList1: TImageList;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    lvMain: TListView;
    ImageList2: TImageList;
    ToolButton13: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvMainDblClick(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

    { Private declarations }
  public
    main:THH;

    { Public declarations }
    procedure ShowPointEditor;
    procedure SaveTH;
    procedure LoadTH;
    procedure REfreshList;
    procedure AddTeoHod;
    procedure AddNivHod;
    procedure EditElement;
  end;

var
  fTHMaker: TfTHMaker;

implementation
uses thsourceeditor, theditor;
{$R *.dfm}

procedure TfTHMaker.AddNivHod;
begin

end;

procedure TfTHMaker.AddTeoHod;
var f:TfTHEditor;
     th:THTeoHod;
begin
  th:=THTeoHod.Create;
//  main.objectlist.Add(THTeoHod.Create);
  f:=TfTHEditor.Create(self);
  f.th:=th;
  if f.ShowModal=mrOk then
  begin
    main.objectlist.Add(th);
    RefreshList;
  end;
end;

procedure TfTHMaker.EditElement;
var el:THElement;
    f:TfTHEditor;
begin
  el:=THElement(lvMain.Selected.Data);
  case el.elementtype of
  telTeoHod:
  begin
    f:=TfTHEditor.Create(self);
    f.th:=THTeoHod(el);
    if f.ShowModal=mrOk then
    begin
      REfreshList;
    end;
  end;
  end;
end;

procedure TfTHMaker.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if fSourceEditor<>nil then fSourceEditor.Free;
  
end;

procedure TfTHMaker.FormCreate(Sender: TObject);
begin
  main:=THH.Create;
end;

procedure TfTHMaker.LoadTH;
begin
  if OpenDialog1.Execute then
  begin
    main.Load(OpenDialog1.FileName);
    REfreshList;
  end;
end;

procedure TfTHMaker.lvMainDblClick(Sender: TObject);
begin
  if main.objectlist.Count=0 then
    exit;
  if lvMain.Selected<>nil then
  begin
    EditElement;
  end;
end;

procedure TfTHMaker.REfreshList;
var
  i: Integer;
  el:THElement;
  l:TListItem;
begin
  lvMain.Items.Clear;
  for i := 0 to main.objectlist.Count - 1 do
  begin
    el:=THElement(main.objectlist[i]);
    case el.elementtype of
    telTeoHod:begin
                l:=lvMain.Items.Add;
                l.ImageIndex:=1;
                l.Caption:=el.name;
                l.Data:=el;
              end;
    end;
  end;

end;

procedure TfTHMaker.SaveTH;
begin
  SaveDialog1.FileName:=main.filename;
  if SaveDialog1.Execute then
  begin
    main.Save(SaveDialog1.FileName);
  end;
end;

procedure TfTHMaker.ShowPointEditor;
var f:TfSourceEditor;
begin
  if fSourceEditor<>nil then
     fSourceEditor.Show else
  begin
    fSourceEditor:=TfSourceEditor.Create(self);
    fSourceEditor.plist:=globalpoints;
    fSourceEditor.Show;
  end;
//  f.Free;
end;

procedure TfTHMaker.ToolButton10Click(Sender: TObject);
begin
  ShowPointEditor;
end;

procedure TfTHMaker.ToolButton1Click(Sender: TObject);
begin
  SaveTH;
end;

procedure TfTHMaker.ToolButton2Click(Sender: TObject);
begin
  LoadTH;
end;

procedure TfTHMaker.ToolButton4Click(Sender: TObject);
begin
  AddTeoHod;
end;

end.
