unit smez;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids;

type
  TfSmez = class(TForm)
    StringGrid1: TStringGrid;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Button3: TButton;
    ComboBox4: TComboBox;
    Button4: TButton;
    ComboBox5: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
     scount:integer;
     procedure ClearSmez;
    { Public declarations }
  end;

var
  fSmez: TfSmez;

implementation

{$R *.DFM}

procedure TfSmez.FormCreate(Sender: TObject);
begin
  StringGrid1.Cells[0,0]:='от';
  StringGrid1.Cells[1,0]:='до';
  StringGrid1.Cells[2,0]:='кад.номер';
  StringGrid1.Cells[3,0]:='Ф. И. О.';
  StringGrid1.ColWidths[0]:=60;
  StringGrid1.ColWidths[1]:=60;
  StringGrid1.ColWidths[2]:=120;
  StringGrid1.ColWidths[3]:=250;
end;

procedure TfSmez.Button3Click(Sender: TObject);
begin
  StringGrid1.Cells[0,scount+1]:=ComboBox1.Text;
  StringGrid1.Cells[1,scount+1]:=ComboBox2.Text;
  StringGrid1.Cells[2,scount+1]:=ComboBox4.Text;
  StringGrid1.Cells[3,scount+1]:=ComboBox3.Text;
  Combobox1.Text:=ComboBox2.Text;
  ComboBox2.Text:='';
  ComboBox3.Text:='';
  ComboBox4.Text:='';
  inc(scount);
end;

procedure TfSmez.ComboBox4Change(Sender: TObject);
begin
  ComboBox3.ItemIndex:=ComboBox4.ItemIndex;
end;

procedure TfSmez.ComboBox3Change(Sender: TObject);
begin
  ComboBox4.ItemIndex:=ComboBox3.ItemIndex;
end;

procedure TfSmez.Button4Click(Sender: TObject);
begin
  dec(scount);
end;

procedure TfSmez.ClearSmez;
var i,j:integer;
begin
  scount:=0;
  for i:=0 to 3 do
    for j:=1 to 99 do
    StringGrid1.Cells[i,j]:='';
end;

end.
