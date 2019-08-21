unit pointsetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,M2Addon, M2AddonD;

type
  TfPointSetup = class(TForm)
    Button1: TButton;
    leStyleName: TLabeledEdit;
    Label1: TLabel;
    cbSemField: TComboBox;
    Button2: TButton;
    Button3: TButton;
    cbPrecSemField: TComboBox;
    Label2: TLabel;
    lePrecPointStyle: TLabeledEdit;
    bSelectPrecStyle: TButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    leCadKvartal: TLabeledEdit;
    Label3: TLabel;
    cbKvartalField: TComboBox;
    bSelectKvartal: TButton;
    Bevel3: TBevel;
    Label4: TLabel;
    cbCadNom: TComboBox;
    leUnPrecBorder: TLabeledEdit;
    Button4: TButton;
    Bevel5: TBevel;
    lePrecBorder: TLabeledEdit;
    Button5: TButton;
    Bevel6: TBevel;
    Label5: TLabel;
    cbCategory: TComboBox;
    cbNazn: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    cbIspolz: TComboBox;
    Label8: TLabel;
    cbAddrNP: TComboBox;
    Label9: TLabel;
    cbAddrStreet: TComboBox;
    Label10: TLabel;
    cbAddrHouse: TComboBox;
    Label11: TLabel;
    cbAddrOrient: TComboBox;
    Label12: TLabel;
    cbAddrOrientDist: TComboBox;
    Label13: TLabel;
    cbAddrOrientNapr: TComboBox;
    Label14: TLabel;
    cbPrecision: TComboBox;
    cbRight: TComboBox;
    Label15: TLabel;
    Label16: TLabel;
    cbRightSubject: TComboBox;
    cbDocSQ: TComboBox;
    Label17: TLabel;
    lePartStl: TLabeledEdit;
    Button6: TButton;
    cbPartKN: TComboBox;
    Label18: TLabel;
    cbPartName: TComboBox;
    Label19: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure SetFields(stl:TM2ID;cbb:TComboBox);
  public
    selstl,precselstl,kvstl,precborderstl,unprecborderstl,partstl:string;
    { Public declarations }
  end;

var
  fPointSetup: TfPointSetup;

implementation
uses selstyle, addn, Ingeo_TLB;
{$R *.dfm}

procedure TfPointSetup.Button1Click(Sender: TObject);
var f:TfSelectStyle;
//    selstl:string;
begin
  f:=TfSelectStyle.Create(self);
  if f.ShowModal=mrOk then
  begin
    case (Sender as TControl).Tag of
    1: begin
        leStyleName.Text:=f.trv1.Selected.Parent.Text+'\'+f.trv1.Selected.Text;
        selstl:=PM2ID(f.trv1.Selected.data)^;
        SetFields(selstl,cbSemField);
       end;
    2: begin
        lePrecPointStyle.Text:=f.trv1.Selected.Parent.Text+'\'+f.trv1.Selected.Text;
        precselstl:=PM2ID(f.trv1.Selected.data)^;
        SetFields(precselstl, cbPrecSemField);
       end;
    3: begin
        leCadKvartal.Text:=f.trv1.Selected.Parent.Text+'\'+f.trv1.Selected.Text;
        kvstl:=PM2ID(f.trv1.Selected.data)^;
        SetFields(kvstl, cbKvartalField);
       end;
    4: begin
        leUnPrecBorder.Text:=f.trv1.Selected.Parent.Text+'\'+f.trv1.Selected.Text;
        unprecborderstl:=PM2ID(f.trv1.Selected.data)^;
//        SetFields(kvstl, cbKvartalField);
       end;
    5: begin
        lePrecBorder.Text:=f.trv1.Selected.Parent.Text+'\'+f.trv1.Selected.Text;
        precborderstl:=PM2ID(f.trv1.Selected.data)^;
//        SetFields(kvstl, cbKvartalField);
       end;
    6: begin
        lePartStl.Text:=f.trv1.Selected.Parent.Text+'\'+f.trv1.Selected.Text;
        partstl:=PM2ID(f.trv1.Selected.data)^;
        SetFields(partstl, cbPartKN);
        SetFields(partstl, cbPartName);
       end;
    end; //case
  end;
end;

procedure TfPointSetup.SetFields(stl:TM2ID;cbb:TComboBox);
var sts:IIngeoSemTables;
    st:IIngeoSemTable;
    i,fi,fc,sc:integer;
    sellar:TM2ID;
begin
  sellar:=gAddon2.ActiveDb.StyleFromID(stl).Layer.ID;
  cbb.Items.Clear;
  sts:=gAddon2.ActiveDB.LayerFromID(sellar).SemTables;
//  sts:=gAddon2.ActiveProjectView.ActiveLayerView.Layer.SemTables;

  sc:=sts.Count;
  for i:=0 to sc-1 do
  begin
    st:=sts.Item[i];
    fc:=st.FieldInfos.Count;
    for fi:=0 to fc-1 do
    begin
      cbb.Items.Add('{'+st.Name+'.'+st.FieldInfos.Item[fi].FieldName+'}');
    end;
  end;
end;

procedure TfPointSetup.FormShow(Sender: TObject);
var sname,astl:string;
begin
  sname:=GAddon2.ActiveDb.StyleFromID(selstl).Layer.Name+'\'+GAddon2.ActiveDb.StyleFromID(selstl).Name;
  leStyleName.Text:=sname;
  sname:=GAddon2.ActiveDb.StyleFromID(precselstl).Layer.Name+'\'+GAddon2.ActiveDb.StyleFromID(precselstl).Name;
  lePrecPointStyle.Text:=sname;
  sname:=GAddon2.ActiveDb.StyleFromID(kvstl).Layer.Name+'\'+GAddon2.ActiveDb.StyleFromID(kvstl).Name;
  leCadKvartal.Text:=sname;
  sname:=GAddon2.ActiveDb.StyleFromID(precborderstl).Layer.Name+'\'+GAddon2.ActiveDb.StyleFromID(precborderstl).Name;
  lePrecBorder.Text:=sname;
  sname:=GAddon2.ActiveDb.StyleFromID(unprecborderstl).Layer.Name+'\'+GAddon2.ActiveDb.StyleFromID(unprecborderstl).Name;
  leUnPrecBorder.Text:=sname;
  sname:=GAddon2.ActiveDb.StyleFromID(partstl).Layer.Name+'\'+GAddon2.ActiveDb.StyleFromID(partstl).Name;
  lePartStl.Text:=sname;
  SetFields(partstl,cbPartKN);
  SetFields(partstl,cbPartName);

  SetFields(selstl,cbSemField);
  SetFields(precselstl, cbPrecSemField);
  SetFields(kvstl, cbKvartalField);
  astl:=gAddon2.ActiveDb.LayerFromID( gAddon.MapProject.ActiveLayer).Styles.Item[0].ID;
  SetFields(astl, cbCadNom);
  SetFields(astl, cbCategory);
  SetFields(astl, cbNazn);
  SetFields(astl, cbIspolz);
  SetFields(astl, cbAddrNP);
  SetFields(astl, cbAddrStreet);
  SetFields(astl, cbAddrHouse);
  SetFields(astl, cbAddrOrient);
  SetFields(astl, cbAddrOrientDist);
  SetFields(astl, cbAddrOrientNapr);
  SetFields(astl, cbPrecision);
  SetFields(astl, cbRight);
  SetFields(astl, cbRightSubject);
  SetFields(astl, cbDocSQ);

end;

end.
