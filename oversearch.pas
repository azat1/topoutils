unit oversearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList;

type
  TfOverSearch = class(TForm)
    bSEarch: TButton;
    bClose: TButton;
    bSetup: TButton;
    tvList: TTreeView;
    ImageList1: TImageList;
    ProgressBar1: TProgressBar;
    CheckBox1: TCheckBox;
    procedure tvListDblClick(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure bSetupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bSEarchClick(Sender: TObject);
  private
    stllist:TStringList;
    cfgpath:string;
    ovlarlist:olevariant;
    inwork:boolean;
    procedure LoadParams;
    procedure SaveParams;
    procedure MakeSearch;
    procedure MakeObjectList(s:TStringList);
    procedure MakeObjectSearch(s:string);
    function FindObject(s:string):TTreeNode;
    function FindNode(t:TTreenode;s:string):TTreeNode;
    function InView(obj:string):boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fOverSearch: TfOverSearch;

implementation
uses Ingeo_TLB,addn ,mselstyle, M2Addon,M2AddonD;
{$R *.dfm}

procedure TfOverSearch.bSEarchClick(Sender: TObject);
begin
  if inwork then
  begin
    inwork:=False;
    bSEarch.Caption:='Найти';
  end else
  begin
    inwork:=True;
    bSEarch.Caption:='Стоп';
    MakeSearch;
  end;
end;

procedure TfOverSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveParams;
  Action:=caFree;
end;

procedure TfOverSearch.FormShow(Sender: TObject);
begin

  //...
  windows.SetParent(Handle,gAddon2.MainWindow.Handle);
  LoadParams;
end;

procedure TfOverSearch.LoadParams;
begin
  try
  stllist.LoadFromFile(cfgpath+'oversearch.dat');
  except
  end;
end;

procedure TfOverSearch.SaveParams;
begin
  stllist.SAveToFile(cfgpath+'oversearch.dat');
end;

procedure TfOverSearch.FormCreate(Sender: TObject);
begin
  cfgpath:=ExtractFilePath(Application.ExeName);
  stllist:=TStringList.Create;
  inwork:=False;
end;

procedure TfOverSearch.bSetupClick(Sender: TObject);
var f:TfMSelectStyle;
begin
  f:=TfMSelectStyle.Create(self,stllist);
  f.ShowModal;

end;

procedure TfOverSearch.bCloseClick(Sender: TObject);
begin
  Close;

end;

procedure TfOverSearch.MakeSearch;
var oblist:TStringList;
    i:integer;
begin
  oblist:=TStringList.Create;
  oblist.Sorted:=True;
  oblist.Duplicates:=dupIgnore;
  tvList.Items.Clear;
  MakeObjectList(oblist);
  for i:=0 to oblist.Count-1 do
  begin
    MakeObjectSearch(oblist[i]);
    ProgressBar1.Position:=i*100 div oblist.Count;
    Application.ProcessMessages;
    if not inwork then exit;
  end;
  oblist.Free;
end;

procedure TfOverSearch.MakeObjectSearch(s: string);
var i:integer;
    mq:IIngeoMapObjectsQuery;
    oid,larid:widestring;

    vr,cvr:TTreeNode;
begin

    mq:=gAddon2.ActiveDb.MapObjects.QueryByObject(ovlarlist,s,incrContains,incrContains);
    if mq.EOF then exit;
    try
    vr:=FindObject(s);
    except
        on e:Exception do ShowMessage('Ошибка при поиске в списке');
    end;
    while not mq.EOF do
    begin
      try
      mq.Fetch(larid,oid,i);
      cvr:=tvList.Items.AddChild(vr,oid);
      cvr.ImageIndex:=0;
      except
        on e:Exception do ShowMessage('Ошибка при добавлении в список');
      end;
    end;
end;

procedure TfOverSearch.MakeObjectList(s: TStringList);
var i,spi:integer;
    lar,oid:widestring;
    stl:IIngeoStyle;
    larlist:TStringList;
    mq:IIngeoMapObjectsQuery;
    obj:IIngeoMapObject;
begin
  larlist:=TStringList.Create;
  larlist.Sorted:=True;
  larlist.Duplicates:=dupIgnore;
  for i:=0 to stllist.Count-1 do
  begin
    stl:=gAddon2.ActiveDb.StyleFromID(stllist[i]);
    lar:=stl.Layer.ID;
    larlist.Add(lar);
    mq:=gAddon2.ActiveDb.MapObjects.QueryByStyle(stllist[i],inqsOneOrMore);
    while not mq.EOF do
    begin
      mq.Fetch(lar,oid,spi);
//      obj:=gAddon2.ActiveDb.MapObjects.GetObject(oid);
      if CheckBox1.Checked then
      begin
        if InView(oid) then s.Add(oid);
      end else
      begin
        s.Add(oid);
      end;
    end;
    if not inwork then exit;
  end;
  ovlarlist:=VarArrayCreate([0,larlist.Count-1],varOleStr);
  for i:=0 to larlist.Count-1 do
  begin
    ovlarlist[i]:=larlist[i];
  end;
end;

function TfOverSearch.FindObject(s: string): TTreeNode;
var fn:TTreeNode;
    i:integer;
begin
  fn:=nil;
  for i:=0 to tvList.Items.Count-1 do
  begin

    fn:=FindNode(tvList.Items[i],s);
    if fn<>nil then break;
  end;
  if fn=nil then
  begin
    fn:=tvList.Items.Add(nil,s);
    fn.ImageIndex:=0;
  end;
  Result:=fn;
end;

function TfOverSearch.FindNode(t: TTreenode; s: string): TTreeNode;
var i:integer;
begin
  REsult:=nil;
  if t.Text=s then Result:=t;
  for i:=0 to t.Count-1 do
  begin
    if t.Item[i].Text=s then
    begin
      Result:=t.Item[i];
      exit;
    end;
  end;
end;

procedure TfOverSearch.tvListDblClick(Sender: TObject);
begin
  gAddon2.Selection.SelectAlone(tvList.Selected.Text,-1);
end;

function TfOverSearch.InView(obj: string): boolean;
var r,r2:TM2Rect;
//    objj:IIngeoMApObject;
begin
//  gAddon2.MainWindow.MapWindow.Navigator.

  r:=gAddon.MapView.ZoomRect;
  r2:=gAddon.MapObjects.GetObjectBounds(obj);
  Result:=M2RectIntersectsRect(r,r2);
end;

end.
