unit templateslist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, comobj, Word_TLB;

type
  TfTemplatesList = class(TForm)
    Button1: TButton;
    Button2: TButton;
    lMain: TListBox;
    bAdd: TButton;
    bDelete: TButton;
    OpenDialog1: TOpenDialog;
    bOpenTemplate: TButton;
    procedure bAddClick(Sender: TObject);
    procedure bDeleteClick(Sender: TObject);
    procedure bOpenTemplateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fTemplatesList: TfTemplatesList;

implementation
uses frm;
{$R *.dfm}

procedure TfTemplatesList.bAddClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    lMain.Items.Add(OpenDialog1.FileName);
  end;
end;

procedure TfTemplatesList.bDeleteClick(Sender: TObject);
begin
  if lMain.ItemIndex>=0 then
  begin
    lMain.Items.Delete(lMain.ItemIndex);
  end;
end;

procedure TfTemplatesList.bOpenTemplateClick(Sender: TObject);
var v:variant;
    s1,s2:olevariant;
begin
  if lMain.ItemIndex<>-1 then
  begin
    v:=CreateOLEObject('Word.Application');
    s1:=lMain.Items.Strings[lMain.ItemIndex];
    s2:=wdOpenFormatTemplate;
    v.Documents.Open(s1,,,,,,,,,s2);
    v.Visible:=True;
  end;
end;

end.
