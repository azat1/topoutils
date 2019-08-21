unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  M2Addon, M2AddonD, M2AddonImp, DllForm;

type
  TMainForm = class(TM2AddonForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TM2AddonForm;

implementation

{$R *.DFM}

end.
