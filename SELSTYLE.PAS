unit selstyle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, addn , M2Addon;

type
  TfSelectStyle = class(TForm)
    trv1: TTreeView;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure trv1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    selstyle:string;
    { Public declarations }
  end;

var
  fSelectStyle: TfSelectStyle;

implementation

{$R *.DFM}

procedure TfSelectStyle.FormCreate(Sender: TObject);
var map,lar,tbl,obj,stl:TM2ID;
    mapl,stll:IM2IDsList;

    k,ccs,i,cc,cc1,j:integer;
    data:TM2ObjectData;
    attr:TM2LayerAttrs;
    mattr:TM2MapAttrs;
    tbls:PM2TableData;
    f,v:PM2Variant;
    tblattr:TM2TableAttrs;
    tname:String;
    m,n,l:TTreeNode;
    sattr:TM2StyleAttrs;
    pid:PM2ID;
begin
  mapl:=gAddon.MapProject.GetMapList;
  mapl.i_GetCount(cc1);
  for j:=0 to cc1-1 do
  begin

//  map:=gAddon.MapProject.ActiveMap;
  mapl.i_GetItem(j,map);
  gAddon.GISDatabase.GetMapAttrs(map,mattr);
  m:=trv1.Items.Add(nil,mattr.Name);
  gAddon.MapProject.GetLayerList(map).i_GetCount(cc);
  for i:=0 to cc-1 do
  begin
    gAddon.MapProject.GetLayerList(map).i_GetItem(i,lar);
    gAddon.GISDatabase.GetLayerAttrs(lar,attr);
    n:=trv1.Items.AddChild(m,attr.Name);
    new(pid);
    pid^:=lar;
    n.Data:=pid;
    stll:=gAddon.GISDatabase.GetStyleList(lar);
    stll.i_GetCount(ccs);
    for k:=0 to ccs-1 do
    begin
      stll.i_GetItem(k,stl);
      gAddon.GISDatabase.GetStyle(stl).i_GetAttrs(sattr);
      l:=trv1.Items.AddChild(n,sattr.Name);
      new(pid);
      pid^:=stl;
      l.Data:=pid

    end;
  end;
  end;

end;

procedure TfSelectStyle.trv1DblClick(Sender: TObject);
begin
  if trv1.Selected.Level=2 then
  begin
    selstyle:=pm2id(trv1.Selected.Data)^;
    ModalREsult:=mrOk;
  end;
end;

end.
