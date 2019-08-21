unit layoutfindreplaceform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, layoutfindreplace, Ingeo_TLB, DllForm;

type
  TfLayoutFindReplaceForm = class(TM2AddonForm)
    Label1: TLabel;
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    eFind: TEdit;
    Label3: TLabel;
    eReplace: TEdit;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    lpr:TLayoutMassOps;
    { Private declarations }
  public
    app:IIngeoApplication;
    { Public declarations }
  end;

var
  fLayoutFindReplaceForm: TfLayoutFindReplaceForm;

  procedure StartLayoutFindReplace(app:IIngeoApplication);


implementation

  procedure StartLayoutFindReplace(app:IIngeoApplication);
  var
  f: TfLayoutFindReplaceForm;
  begin
    f:=TfLayoutFindReplaceForm.Create(nil);
    f.app:=app;
    f.Show;
    
  end;

{$R *.dfm}


procedure TfLayoutFindReplaceForm.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute() then
  begin
    ListBox1.Items.AddStrings(OpenDialog1.Files);
  end;
end;

procedure TfLayoutFindReplaceForm.Button2Click(Sender: TObject);
begin
  ListBox1.Items.Clear;
end;

procedure TfLayoutFindReplaceForm.Button3Click(Sender: TObject);
begin
  if efind.Text='' then
  begin
    ShowMessage('Не заполнено поле найти!');
    exit;
  end;
  lpr:=TLayoutMassOps.Create(app);
  lpr.FindReplace(ListBox1.Items,eFind.Text,eReplace.Text);
  lpr.Free;

end;

procedure TfLayoutFindReplaceForm.Button4Click(Sender: TObject);
begin
  lpr:=TLayoutMassOps.Create(app);
  lpr.Print(ListBox1.Items);//,eFind.Text,eReplace.Text);
  lpr.Free;

end;

procedure TfLayoutFindReplaceForm.FormShow(Sender: TObject);
begin
  //lpr:=TLayoutMassOps.Create(app);
end;

end.
