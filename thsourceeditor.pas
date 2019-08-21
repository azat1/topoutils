unit thsourceeditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, thclass, M2Addon, DllForm, ComCtrls, ActnList,
  ImgList, ToolWin;

type
  TfSourceEditor = class(TM2AddonForm)
    sgPoints: TStringGrid;
    Button3: TButton;
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    ImageList1: TImageList;
    acAdd: TAction;
    acAddFromMap: TAction;
    acSetCoords: TAction;
    acDelete: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure FormActivate(Sender: TObject);
    procedure sgPointsDblClick(Sender: TObject);
    procedure sgPointsKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure sgPointsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure sgPointsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    plist:THPointList;
    { Public declarations }
    procedure LoadPList;
  end;

var
  fSourceEditor: TfSourceEditor;

implementation

{$R *.dfm}

procedure TfSourceEditor.Button1Click(Sender: TObject);
begin
  if plist.Count=0 then exit;
  plist.Delete( sgPoints.Row-1);
  LoadPList;
end;

procedure TfSourceEditor.Button3Click(Sender: TObject);
begin
  Close;
end;

procedure TfSourceEditor.Button4Click(Sender: TObject);
begin
  plist.Add(THPoint.Create('',0,0,0,thclass.ptSource));
  LoadPList;
end;

procedure TfSourceEditor.FormActivate(Sender: TObject);
begin
  LoadPList;
end;

procedure TfSourceEditor.FormCreate(Sender: TObject);
begin
  sgPoints.Cells[1,0]:='Èìÿ';
  sgPoints.Cells[2,0]:='X';
  sgPoints.Cells[3,0]:='Y';
  sgPoints.Cells[4,0]:='H';
  sgPoints.Cells[5,0]:='Òèï';
  sgPoints.ColWidths[0]:=10;
end;

procedure TfSourceEditor.FormShow(Sender: TObject);
begin
  LoadPList;
end;

procedure TfSourceEditor.LoadPList;
var i,j:integer;
    p:THPoint;
begin
  j:=0;

  for i:=0  to plist.Count - 1 do
  begin
    p:=plist.GetPoint(i);

      inc(j);
      sgPoints.Cells[1,j]:=p.name;
      sgPoints.Cells[2,j]:=Format('%.4f',[ p.X]);
      sgPoints.Cells[3,j]:=Format('%.4f',[ p.Y]);
      sgPoints.Cells[4,j]:=Format('%.4f',[ p.Z]);
      sgPoints.Cells[5,j]:=PointTypeToStr(p.ptype);
      sgPoints.Objects[0,j]:=p;
  end;
  if j=0 then
  begin
    sgPoints.RowCount:=2;
  end
    else
  begin
    sgPoints.RowCount:=j+1;
  end;

end;

procedure TfSourceEditor.sgPointsDblClick(Sender: TObject);
var p:THPoint;
begin
  if (sgPoints.Col=5) and (sgPoints.Row>0) and (plist.Count>0)   then
  begin
      p:=THPoint( sgPoints.Objects[0,sgPoints.Row]);
      p.ChangePointType;
      sgPoints.Cells[5,sgPoints.Row]:=PointTypeToStr(p.ptype);

  end;

end;

procedure TfSourceEditor.sgPointsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_DOWN then
  begin
    if (sgPoints.Row=(sgPoints.RowCount-1)) or (sgPoints.RowCount=1) then
    begin
      plist.Add(THPoint.Create('',0,0,0,thclass.ptSource));
      LoadPList;
    end;
  end;
end;

procedure TfSourceEditor.sgPointsKeyPress(Sender: TObject; var Key: Char);
var p:THPoint;
begin
  if (sgPoints.Col=5) and (plist.Count>0)  then
  begin
    if Key=#32 then
    begin
      p:=THPoint( sgPoints.Objects[0,sgPoints.Row]);
      p.ChangePointType;
      sgPoints.Cells[5,sgPoints.Row]:=PointTypeToStr(p.ptype);
    end;
    key:=#0;
  end;
end;

procedure TfSourceEditor.sgPointsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  if plist.Count=0 then
  begin
    plist.Add(THPoint.Create('',0,0,0,ptSource));
    sgPoints.Objects[0,Arow]:=plist.GetPoint(0);
  end;

  case ACol of
  1:begin
      THPoint(sgPoints.Objects[0,ARow]).name:=Value;
    end;
  2:begin
      if not TryStrToFloat(Value,THPoint(sgPoints.Objects[0,ARow]).x) then
      begin
//        LoadPList;
      end;
//       THPoint(sgPoints.Objects[0,ARow]).name:=Value;
    end;
  3:begin
      if not TryStrToFloat(Value,THPoint(sgPoints.Objects[0,ARow]).y) then
      begin
//        LoadPList;
      end;
    end;
  4:begin
      if not TryStrToFloat(Value,THPoint(sgPoints.Objects[0,ARow]).z) then
      begin
//        LoadPList;
      end;
    end;
  end;
end;

end.
