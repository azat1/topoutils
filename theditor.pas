unit theditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, thclass, Mask;

type
  TfTHEditor = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure cbOnClick(Sender:TObject);
  private
    { Private declarations }
  public
    plist:THPointList;
    th:THTeoHod;
    toppos,tdist:integer;
    p1,p2,p3:integer;
    w1,w2,w3:integer;
    procedure LoadTH;
    procedure SaveTH;
    function AddCombo(text:string):TCombobox;
    procedure AddEdits(angle,dist:double);
    function AddEdit(text:string):TEdit;
    procedure CreateControls;
    { Public declarations }
  end;

var
  fTHEditor: TfTHEditor;

implementation

{$R *.dfm}

{ TfTHEditor }

function TfTHEditor.AddCombo(text: string):TCombobox;
var cb:TComboBox;
begin
  cb:=TComboBox.Create(self);
  cb.Parent:=ScrollBox1;
  cb.Text:=text;
  cb.OnKeyDown:=ComboBox1KeyDown;
  cb.OnKeyPress:=Edit1KeyPress;
  Result:=cb;
end;

function TfTHEditor.AddEdit(text: string): TEdit;
var ed:TEdit;
begin
  ed:=TEdit.Create(self);
  ed.Parent:=ScrollBox1;
  ed.Text:=text;
  REsult:=ed;
  ed.OnKeyDown:=ComboBox1KeyDown;
  ed.OnKeyPress:=Edit1KeyPress;
end;

procedure TfTHEditor.AddEdits(angle, dist: double);
var ed:TEdit;
begin
  ed:=TEdit.Create(self);
  ed.Parent:=ScrollBox1;
  ed.Left:=p2;
  ed.Text:=AngleToStr(angle);
  ed.Top:=toppos+tdist div 2;
  ed.Width:=w2;
  ed.OnKeyDown:=ComboBox1KeyDown;

  ed:=TEdit.Create(self);
  ed.Parent:=ScrollBox1;
  ed.Left:=p3;
  ed.Text:=Format('%.3f',[dist]);
  ed.Top:=toppos+tdist div 2;
  ed.Width:=w3;
  ed.OnKeyDown:=ComboBox1KeyDown;

end;

procedure TfTHEditor.Button2Click(Sender: TObject);
begin
  SaveTH;
end;

procedure TfTHEditor.cbOnClick(Sender: TObject);
begin
 //
end;

procedure TfTHEditor.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var t:TControl;
begin
  //
  if Key=VK_RETURN then
  begin
    key:=0;
    SelectNext(TWinControl(sender),true,true);

  end;
end;

procedure TfTHEditor.CreateControls;
var
  i: Integer;
  cb:TComboBox;
  ed:TEdit;
begin
  for i := 0 to 100 do
  begin
    cb:=AddCombo('');
    cb.Top:=i*tdist;
    cb.Left:=p1;
    cb.Width:=w1;

    ed:=AddEdit('');
    ed.Left:=p2;
    ed.Width:=w2;
    ed.Top:=i*tdist+tdist div 2;
    if i=0 then
      ed.Visible:=False;
    ed:=AddEdit('');
    ed.Left:=p3;
    ed.Width:=w3;
    ed.Top:=i*tdist+tdist div 2;
    if i=0 then
      ed.Visible:=False;

  end;

end;

procedure TfTHEditor.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  //
  if key=#13 then
    key:=#0;
end;

procedure TfTHEditor.FormCreate(Sender: TObject);
begin
  p1:=10;p2:=120;p3:=230;
  w1:=100;w2:=100;w3:=100;
  tdist:=24;
  toppos:=10;
  plist:=globalpoints;
  CreateControls;
end;

procedure TfTHEditor.FormShow(Sender: TObject);
begin
  LoadTH;
end;

procedure TfTHEditor.LoadTH;
var
  i: Integer;
  cb:TComboBox;
  ed:TEdit;
  vect:THVector;
begin
  if th.vectorlist.Count=0 then
  begin
    exit;
  end;
  cb:=TComboBox( ScrollBox1.controls[0]);
//  cb.SetFocus;
  cb.Text:=th.vectorlist.fp.name;
  cb:=TComboBox( ScrollBox1.controls[3]);
  cb.Text:=th.vectorlist.sp.name;

  for i := 0 to th.vectorlist.Count - 1 do
  begin
    vect:=th.vectorlist.GetVector(i);
    cb:=TComboBox( ScrollBox1.controls[(i+2)*3]);
    cb.Text:=vect.fp.name;
    ed:=TEdit(ScrollBox1.controls[(i+2)*3-2]);
    ed.Text:=AngleToStr(vect.measangle);
    ed:=TEdit(ScrollBox1.controls[(i+2)*3-1]);
    ed.Text:=Format('%.3f',[vect.measdist]);
  end;

end;

procedure TfTHEditor.SaveTH;
var vl:THVectorList;
    v:THVector;
    cb:TComboBox;
    ed:TEdit;
  i: Integer;
  ma,md:double;
  p:THPoint;
begin
  th.name:='';
  th.vectorlist.Clear;
  cb:=TComboBox(ScrollBox1.Controls[0]);
  p:=plist.GetPointByName(cb.Text);
  if p=nil then
  begin
    p:=THPoint.Create(cb.Text,0,0,0,ptWork);
    plist.Add(p);
  end;
  th.vectorlist.fp:=p;
  th.name:=cb.Text;

  cb:=TComboBox(ScrollBox1.Controls[3]);
  p:=plist.GetPointByName(cb.Text);
  if p=nil then
  begin
    p:=THPoint.Create(cb.Text,0,0,0,ptWork);
    plist.Add(p);
  end;
  th.vectorlist.sp:=p;
  th.name:=th.name+' '+cb.Text;

  for i := 0 to 99 do
  begin
    cb:=TComboBox(ScrollBox1.Controls[(i+1)*3+3]);
    if cb.Text='' then
       break;
    th.name:=th.name+' '+cb.Text;
    p:=plist.GetPointByName(cb.Text);
    if p=nil then
    begin
      p:=THPoint.Create(cb.Text,0,0,0,ptWork);
      plist.Add(p);
    end;
    ed:=TEdit(ScrollBox1.Controls[(i+1)*3+1]);
    ma:=StrToAngle(ed.Text);
    ed:=TEdit(ScrollBox1.Controls[(i+1)*3+2]);
    md:=StrToFloat(ed.Text);
    th.vectorlist.Add(THVector.Create(p,md,ma,atLeft));
  end;

//  v.pst
end;

end.
