unit setup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, addn, M2Addon, Buttons, filectrl,math;

type
  TfSetup = class(TForm)
    Button1: TButton;
    Label5: TLabel;
    eGRes: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    eGLineWidth: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    eFontHeight: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    eFontDx: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    eFontDY: TEdit;
    Label14: TLabel;
    cbScale: TComboBox;
    Label26: TLabel;
    Label27: TLabel;
    fPointSize: TEdit;
    Label28: TLabel;
    Label29: TLabel;
    cbPointForm: TComboBox;
    leSAvePAth: TLabeledEdit;
    Button3: TButton;
    Button4: TButton;
    cbAutoSaveFormat: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    eCadNomFont: TEdit;
    Label4: TLabel;
    Label15: TLabel;
    eDS: TEdit;
    Label16: TLabel;
    eFM: TEdit;
    cbSQType: TCheckBox;
    Label17: TLabel;
    cbPrec: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbExplicitClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadFields;
  public
    { Public declarations }
  end;

var
  fSetup: TfSetup;

implementation
uses selstyle, registry, frm, Ingeo_TLB;
{$R *.DFM}

procedure TFSetup.LoadFields;
var sts:IIngeoSemTables;
    st:IIngeoSemTable;
    i,fi,fc,sc:integer;
    sellar:TM2ID;
begin
  sellar:=gAddon.MapProject.ActiveLayer;
  cbPrec.Items.Clear;
  sts:=gAddon2.ActiveDB.LayerFromID(sellar).SemTables;
  sc:=sts.Count;
  for i:=0 to sc-1 do
  begin
    st:=sts.Item[i];
    fc:=st.FieldInfos.Count;
    for fi:=0 to fc-1 do
    begin
      cbPrec.Items.Add('{'+st.Name+'.'+st.FieldInfos.Item[fi].FieldName+'}');
    end;
  end;
end;

procedure TfSetup.FormCreate(Sender: TObject);
var i,root:integer;
    r:TRegistry;
begin
  r:=TRegistry.Create;
  r.OpenKey('Software\AzSoft\KADASTR',True);

  root:=IfThen(r.ReadInteger('UserSetup')=1,kprUser,kprProject);
  for i:=0 to ComponentCount-1 do
  begin

    if Components[i].Tag<>1 then continue;
    if Components[i].ClassName='TLabeledEdit' then
    begin
      try
      (Components[i] as TLabeledEdit).Text:=
         gAddon.Preferences.GetString(root,kNoId,'kadastr'+(Components[i] as TLabeledEdit).Name,(Components[i] as TLabeledEdit).Text);
      except
        ShowMessage('Ошибка загрузки параметра '+(Components[i] as TLabeledEdit).Name);
      end;
    end;

    if Components[i].ClassName='TEdit' then
    begin
      try
      (Components[i] as TEdit).Text:=
         gAddon.Preferences.GetString(root,kNoId,'kadastr'+(Components[i] as TEdit).Name,(Components[i] as TEdit).Text);
      except
        ShowMessage('Ошибка загрузки параметра '+(Components[i] as TEdit).Name);
      end;
    end;

    if Components[i].ClassName='TComboBox' then
    begin
      try
      (Components[i] as TComboBox).Text:=
      gAddon.Preferences.GetString(root,kNoId,'kadastr'+(Components[i] as TComboBox).Name,(Components[i] as TComboBox).Text);
      except
        ShowMessage('Ошибка загрузки параметра '+(Components[i] as TComboBox).Name);
      end;
    end;

    if Components[i].ClassName='TCheckBox' then
    begin
      try
      (Components[i] as TCheckBox).Checked:=
         gAddon.Preferences.GetString(root,kNoId,'kadastr'+(Components[i] as TCheckBox).Name,'False')='True';
      except
        ShowMessage('Ошибка загрузки параметра '+(Components[i] as TCheckBox).Name);
      end;
    end;

    if Components[i].ClassName='TRadioGroup' then
    begin
      try
      (Components[i] as TRadioGroup).ItemIndex:=StrToInt(
         gAddon.Preferences.GetString(root,kNoId,'kadastr'+(Components[i] as TRadioGroup).Name,
            IntToStr((Components[i] as TRadioGroup).ItemIndex)));
      except
        ShowMessage('Ошибка загрузки параметра '+(Components[i] as TRadioGroup).Name);
      end;
    end;

  end;
end;

procedure TfSetup.FormClose(Sender: TObject; var Action: TCloseAction);
var i,root:integer;
    s:string;
    r:TRegistry;
begin
  exit;

  for i:=0 to ComponentCount-1 do
  begin
    if Components[i].Tag<>1 then continue;

    if Components[i].ClassName='TLabeledEdit' then
    begin
      gAddon.Preferences.SetString(root,kNoId,(Components[i] as TLabeledEdit).Name,(Components[i] as TLabeledEdit).Text);
    end;

    if Components[i].ClassName='TEdit' then
    begin
      gAddon.Preferences.SetString(root,kNoId,(Components[i] as TEdit).Name,(Components[i] as TEdit).Text);
    end;

    if Components[i].ClassName='TComboBox' then
    begin
      gAddon.Preferences.SetString(root,kNoId,(Components[i] as TComboBox).Name,(Components[i] as TComboBox).Text);
    end;

    if Components[i].ClassName='TCheckBox' then
    begin
      if (Components[i] as TCheckBox).Checked then s:='True' else s:='False';
      gAddon.Preferences.SetString(root,kNoId,(Components[i] as TCheckBox).Name,s);
    end;

    if Components[i].ClassName='TRadioGroup' then
    begin
       gAddon.Preferences.SetString(root,kNoId,(Components[i] as TRadioGroup).Name,
            IntToStr((Components[i] as TRadioGroup).ItemIndex));
    end;

  end;
end;



procedure TfSetup.cbExplicitClick(Sender: TObject);
var i:integer;
begin
end;


procedure TfSetup.Button3Click(Sender: TObject);
var dir:string;
begin
  dir:=leSAvePAth.Text;
  if SelectDirectory('Выбрать папку','',dir) then
    leSAvePAth.Text:=dir;
end;

procedure TfSetup.Button1Click(Sender: TObject);
var i,root:integer;
    s:string;
    r:TRegistry;
begin

  for i:=0 to ComponentCount-1 do
  begin
    if Components[i].Tag<>1 then continue;

    if Components[i].ClassName='TLabeledEdit' then
    begin
      gAddon.Preferences.SetString(root,kNoId,'kadastr'+(Components[i] as TLabeledEdit).Name,(Components[i] as TLabeledEdit).Text);
    end;

    if Components[i].ClassName='TEdit' then
    begin
      gAddon.Preferences.SetString(root,kNoId,'kadastr'+(Components[i] as TEdit).Name,(Components[i] as TEdit).Text);
    end;

    if Components[i].ClassName='TComboBox' then
    begin
      gAddon.Preferences.SetString(root,kNoId,'kadastr'+(Components[i] as TComboBox).Name,(Components[i] as TComboBox).Text);
    end;

    if Components[i].ClassName='TCheckBox' then
    begin
      if (Components[i] as TCheckBox).Checked then s:='True' else s:='False';
      gAddon.Preferences.SetString(root,kNoId,'kadastr'+(Components[i] as TCheckBox).Name,s);
    end;

    if Components[i].ClassName='TRadioGroup' then
    begin
       gAddon.Preferences.SetString(root,kNoId,'kadastr'+(Components[i] as TRadioGroup).Name,
            IntToStr((Components[i] as TRadioGroup).ItemIndex));
    end;

  end;
end;

procedure TfSetup.FormShow(Sender: TObject);
begin
//  cbAutoSaveFormat.Items:=MainForm.ComboBox1.Items;
  LoadFields;
end;

end.
