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
    Label3: TLabel;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    eFind: TMemo;
    eReplace: TMemo;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
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

procedure TfLayoutFindReplaceForm.Button5Click(Sender: TObject);
var f:TFontDialog;
begin
  f:=TFontDialog.Create(self);

  if f.Execute(Handle)   then
  begin
    lpr:=TLayoutMassOps.Create(app);
    lpr.FontChange(ListBox1.Items,f.Font.Name);//,eFind.Text,eReplace.Text);
    lpr.Free;
  end;
  
end;

procedure TfLayoutFindReplaceForm.FormShow(Sender: TObject);
begin
  //lpr:=TLayoutMassOps.Create(app);
end;

end.
