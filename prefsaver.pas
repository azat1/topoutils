unit prefsaver;

interface
uses classes,Ingeo_TLB, Controls,stdCtrls, EXTcTRLS, sysutils;
var app:IIngeoApplication;
    scope:integer;

procedure SaveControl(ctrl:TControl;keyprefx:string);
procedure Loadcontrol(ctrl:TControl;keyprefx:string);
function LayerName(laR:string):string;
implementation

function LayerName(laR:string):string;
var ilar:IIngeoLayer;
begin
  ilaR:=app.ActiveDb.LayerFromID(lar);
  REsult:=ilar.Map.Name+'\'+ilar.Name;
end;

procedure SaveControl(ctrl:TControl;keyprefx:string);
var ce:TEdit;
    key:string;
begin
  key:=keyprefx+'_'+ ctrl.Name;
  if ctrl.ClassName='TEdit' then
  begin
    app.UserProfile.Put(scope,'',key+'_1', Copy(TEdit( ctrl).Text,0,100));
    app.UserProfile.Put(scope,'',key+'_2', Copy(TEdit( ctrl).Text,100,100));
  end;
  if ctrl.ClassName='TLabeledEdit' then
  begin
    app.UserProfile.Put(scope,'',key+'_1', Copy(TLabeledEdit( ctrl).Text,0,100));
    app.UserProfile.Put(scope,'',key+'_2', Copy(TLabeledEdit( ctrl).Text,100,100));
  end;
  if ctrl.ClassName='TComboBox' then
  begin
    app.UserProfile.Put(scope,'',key+'_1', Copy(TComboBox( ctrl).Text,0,100));
    app.UserProfile.Put(scope,'',key+'_2', Copy(TComboBox( ctrl).Text,100,100));
  end;
  if ctrl.ClassName='TCheckBox' then
  begin
    app.UserProfile.Put(scope,'',key, BoolToStr(TCheckBox( ctrl).Checked));
  end;
end;

procedure Loadcontrol(ctrl:TControl;keyprefx:string);
var ce:TEdit;
    key:string;
begin
  key:=keyprefx+'_'+ ctrl.Name;
  if ctrl.ClassName='TEdit' then
  begin
    TEdit(ctrl).Text:=
    app.UserProfile.Get(scope,'',key+'_1', Copy(TEdit( ctrl).Text,0,100))+
    app.UserProfile.Get(scope,'',key+'_2', Copy(TEdit( ctrl).Text,100,100));
  end;
  if ctrl.ClassName='TLabeledEdit' then
  begin
    TLabeledEdit(ctrl).Text:=
    app.UserProfile.Get(scope,'',key+'_1', Copy(TLabeledEdit( ctrl).Text,0,100))+
    app.UserProfile.Get(scope,'',key+'_2', Copy(TLabeledEdit( ctrl).Text,100,100));
  end;
  if ctrl.ClassName='TComboBox' then
  begin
    TComboBox(ctrl).Text:=
    app.UserProfile.Get(scope,'',key+'_1', Copy(TComboBox( ctrl).Text,0,100))+
    app.UserProfile.Get(scope,'',key+'_2', Copy(TComboBox( ctrl).Text,100,100));
  end;
  if ctrl.ClassName='TCheckBox' then
  begin
    TCheckBox( ctrl).Checked:=
     StrToBool( app.UserProfile.Get(scope,'',key, BoolToStr(TCheckBox( ctrl).Checked)));
  end;
end;

end.
