unit addn;

interface
uses
   Windows, ActiveX, M2Addon, M2AddonD, M2AddonImp, Ingeo_TLB, dialogs, controls, InScripting_TLB,eventtest,ComObj;
const
	CLSID_First: TGUID = '{76AC3567-C7B9-4163-9908-30C411D9907F}';
        lickey=11891;

type
	TFAd = class(TM2CustomAddon)
  private
    procedure StartDBExtractor;
	public
		constructor Create;
		destructor Destroy; override;

		function GetMacroList: IM2MacroAttrsList; override;
		function GetBitmap(const aStm: IStream; aBitmap: Longint): Boolean; override;
		procedure ExecuteMacro(aCmd: Longint; const aParams: TM2String); override;
    procedure Activate;
    procedure Activate2;
    procedure StartNavigator;
    procedure StartTransformator;
    procedure StartDivider;
    procedure StartVedomost;
    procedure StartFastPlan;
    procedure StartSplitter;
    procedure StartCoordConverter;
    procedure StartErrorSearch;
    procedure StartDeCurve;
    procedure StartSpecSemCopy;
    procedure StartPodt;
    procedure StartOverSearch;
    procedure StartOkrugl;
    procedure StartEGRZPoints;
    procedure StartTHMaker;
    procedure StartSemTest;
    procedure StartTABImport;
    procedure StartCSVExport;
    procedure StartClearZPoints;
    procedure StartOrientContour;
    procedure StartQuickPlan;
    procedure StartLinZasechka;
    procedure StartPolygon;
    procedure StartLineConnect;
    procedure StartRasterChange;
    procedure StartCoordSystem;
    procedure StartContactDrawer;
    procedure StartPinDrawer;
    procedure StartSemiPinDrawer;
    procedure StartSmartPoint;
    procedure Test;
		procedure Notify(AnAdvise: TM2Notify; const AParams: IM2ParamsList); override;
    procedure EventConnect;
    procedure StartLineText;
    procedure ToLinear;
    procedure CloseAll;
    procedure UnCloseAll;
    procedure Okrugl2;

	end;

var
	gAddon: TFAd = nil;
        gAddon2:IIngeoApplication;
        DemoFlag, PacketMode:boolean;
        excount:integer;
        ecvalue:integer;
function MStrToFloat(s:string):extended;
function MTryStrToFloat(s:string;var e:extended):boolean;
function GetStyleName(stl:string):string;
function GetStyleNameID(stl:string):string;
function GetLayerName(lar:string):string;
implementation

{$R Cmds.res}

uses
	SysUtils, AUtils, frm, packetprint, StrUtils, pkzoimport, katexport,navigator, transformator,
  Forms, divider, vedomost, splitter, coordconverter, errorsearch, decurve,
  specsemcopy,podt,oversearch,okrugl,test,egrzpoint, thmaker, semtest, tabimport,
  csvexport, clearzpoints, contourorient, quickplan, linzasechka, polygoncreator, lineconnect,
  rasterchange, coordsystem, contactdrawer, pins, semipindrawe, linetext,cpwindow, tolinears,
  ufastselect, cntrcloser, lineconnect2, vectorrotate, dbextractor, makecircle, createzone, deletenear, objselectform, copybystyle, smartpointform,
  layoutfindreplaceform, zasechkaForm, okruglform2;

const
	//Команда начать измерение расстояния
	cmActivate =  1;
	cmActivate2 = 2;
        cmNavigator=3;
        cmTransformator=4;
        cmDivider=5;
        cmVedomost=6;
        cmFastPlan=7;
        cmSplitter=8;
        cmCoordConverter=9;
        cmErrorSearch=10;
        cmDecurve=11;
        cmSpecSemCopy=12;
        cmPodt=13;
        cmOverSearch=14;
        cmOkrugl=15;
        cmTest=16;
        cmEGRZPoint=17;
        cmTHMaker=18;
        cmSemTest=19;
        cmTabImport=20;
        cmCSVExport=21;
        cmClearZPoints=22;
        cmOrientContour=23;
        cmQuickPlan=24;
        cmLinZasechka=25;
        cmPolygonCreator=26;
        cmLineConnect=27;
        cmRasterChange=28;
        cmCoordSystem=29;
        cmContactDrawer=30;
        cmPinDrawer=31;
        cmSemiPinDrawer=32;
        cmLineText=33;
        cmCopyWindow=34;
        cmPasteWindow=35;
        cmPasteWindowNoCheck=36;
        cmLineClear=37;
        cmToLinear=38;
        cmFastSelect=39;
        cmCloseAll=40;
        cmUnCloseAll=41;
        cmLineConnect2=42;
        cmVectorRotate=43;
        cmDBExtractor=44;
        cmMakeCircle=45;
        cmCreateZone=46;
        cmDeleteNear=47;
        cmObjectSelect=48;
        cmCopyByStyle=49;
        cmSetPointsSmart=50;
        cmLayoutFindReplace=51;
        cmZasechka=52;
        cmFastSelect2=53;
        cmLineConnect3=54;
        cmOkrugl2=55;

	kMacros: array [0..54] of TM2MacroAttrs = (
		( Command: cmActivate;
			Name: 'SETPOINTS';
			Hint: 'Нумерация точек объектов';
			MenuPath: 'Сервис\Программы\Нумерация точек объектов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmActivate2;
			Name: 'KATEXPORT';
			Hint: 'Экспорт точек в формат Credo_KAT';
			MenuPath: 'Сервис\Программы\Экспорт  в формат Credo KAT';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmNavigator;
			Name: 'NAVIGATOR';
			Hint: 'Навигатор';
			MenuPath: 'Сервис\Программы\Навигатор';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmTransformator;
			Name: 'TRANSFORMATOR';
			Hint: 'Трансформация объектов';
			MenuPath: 'Сервис\Программы\Трансформация объектов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmDivider;
			Name: 'DIVIDER';
			Hint: 'Разделение объектов';
			MenuPath: 'Сервис\Программы\Разделение объектов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmVedomost;
			Name: 'VEDOMOST';
			Hint: 'Ведомость площадей';
			MenuPath: 'Сервис\Программы\Ведомость вычисления площадей';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmFastPlan;
			Name: 'FASTPLAN';
			Hint: 'Макет печати по объекту';
			MenuPath: 'Файл\Печать\Создать макет по объекту';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmSplitter;
			Name: 'SPLITTER';
			Hint: 'Разделение объекта по контурам';
			MenuPath: 'Сервис\Программы\Разделение по контурам';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmCoordConverter;
			Name: 'COORDCONVERTER';
			Hint: 'Преобразование координат';
			MenuPath: 'Сервис\Программы\Преобразование координат';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmErrorSearch;
			Name: 'ERRORSEARCH';
			Hint: 'Поиск некорректных объектов';
			MenuPath: 'Сервис\Программы\Поиск некорректных объектов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmDecurve;
			Name: 'DECURVE';
			Hint: 'Удаление дуг';
			MenuPath: 'Сервис\Программы\Удаление дуг';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmSpecSemCopy;
			Name: 'SPECSEMCOPY';
			Hint: 'Специальное копирование семантики';
			MenuPath: 'Сервис\Программы\Специальное копирование семантики';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmPodt;
			Name: 'PODT';
			Hint: 'Подтяжка';
			MenuPath: 'Сервис\Программы\Подтяжка';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmOverSearch;
			Name: 'OVERSEARCH';
			Hint: 'Поиск перекрыващихся объектов';
			MenuPath: 'Сервис\Программы\Поиск перекрывающихся объектов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmOkrugl;
			Name: 'OKRUGL';
			Hint: 'Округление координат по сетке';
			MenuPath: 'Сервис\Программы\Округление координат по сетке';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmTest;
			Name: 'TEST';
			Hint: 'Округление координат по сетке';
			MenuPath: 'Сервис\Программы\Тестовое окно';
			MenuShortCut: 0;
			ToolbarName: '';
			ToolbarGroup: '';
			Bitmap: 0),
		( Command: cmEGRZPoint;
			Name: 'EGRZPOINT';
			Hint: '';
			MenuPath: 'Сервис\Программы\Импорт точек из БД ЕГРЗ';
			MenuShortCut: 0;
			ToolbarName: '';
			ToolbarGroup: '';
			Bitmap: 0),
		( Command: cmTHMaker;
			Name: 'THMAKER';
			Hint: '';
			MenuPath: 'Сервис\Программы\Уравнивание теодолитных ходов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmSemTest;
			Name: 'SEMTEST';
			Hint: '';
			MenuPath: 'Сервис\Программы\Тест семантики';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmTabImport;
			Name: 'TABIMPORT';
			Hint: '';
			MenuPath: 'Сервис\Программы\Помощник импорта TAB';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmCSVExport;
			Name: 'CSV';
			Hint: '';
			MenuPath: 'Сервис\Экспорт\Координаты объекта в формат CSV';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmClearZPoints;
			Name: 'CLEARZPOINTS';
			Hint: '';
			MenuPath: 'Сервис\Утилиты\Очистка высотных отметок';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmOrientContour;
			Name: 'ORIENT';
			Hint: 'Ориентирование контуров';
			MenuPath: 'Сервис\Утилиты\Ориентирование контуров';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmQuickPlan;
			Name: 'QUICKPLAN';
			Hint: 'Быстрый план участка';
			MenuPath: 'Сервис\Быстрый план участка';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmLinZasechka;
			Name: 'LINZASECHKA';
			Hint: 'Линейная засечка';
			MenuPath: 'Сервис\Линейная засечка';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmPolygonCreator;
			Name: 'POLYGON';
			Hint: 'Построение правильного многоугольника';
			MenuPath: 'Сервис\Программы\Построение многоугольника';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmLineConnect;
			Name: 'LINECONNECT';
			Hint: 'Соединение двух линий';
			MenuPath: 'Сервис\Программы\Соединение двух линий';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmRasterChange;
			Name: 'RASTERCHANGE';
			Hint: 'Сдвиг растров';
			MenuPath: 'Сервис\Программы\Сдвиг растров';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmCoordSystem;
			Name: 'COORDSYSTEM';
			Hint: 'Преобразование системы координат';
			MenuPath: 'Сервис\Программы\Преразование системы координат';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо)';
			ToolbarGroup: 'Утилиты Az Soft (топо)';
			Bitmap: 0),
		( Command: cmContactDrawer;
			Name: 'CONTACTDRAWER';
			Hint: 'Рисование контактных линий';
			MenuPath: 'Сервис\Программы\Рисование контактных линий';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо2)';
			ToolbarGroup: 'Утилиты Az Soft (топо2)';
			Bitmap: 0),
		( Command: cmPinDrawer;
			Name: 'PINDRAWER';
			Hint: 'Вставка столбов';
			MenuPath: 'Сервис\Программы\Вставка столбов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо2)';
			ToolbarGroup: 'Утилиты Az Soft (топо2)';
			Bitmap: 0),
		( Command: cmSemiPinDrawer;
			Name: 'SEMIPINDRAWER';
			Hint: 'Рисование столбов';
			MenuPath: 'Сервис\Программы\Рисование столбов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо2)';
			ToolbarGroup: 'Утилиты Az Soft (топо2)';
			Bitmap: 0),
		( Command: cmLineText;
			Name: 'LINETEXT2';
			Hint: 'Подписывание линий';
			MenuPath: 'Сервис\Программы\Подписывание линий';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо2)';
			ToolbarGroup: 'Утилиты Az Soft (топо2)';
			Bitmap: 0),
		( Command: cmCopyWindow;
			Name: 'COPYWINDOW';
			Hint: 'Скопировать в буфер обмена содержимое окна';
			MenuPath: 'Правка\Копировать содержимое окна';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
		( Command: cmPasteWindow;
			Name: 'PASTEWINDOW';
			Hint: 'Вставить из буфера обмена объекты c ПРОВЕРКОЙ';
			MenuPath: 'Правка\Вставить из буфера обмена';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
		( Command: cmPasteWindowNoCheck;
			Name: 'PASTEWINDOWNOCHECK';
			Hint: 'Вставить из буфера обмена объекты БЕЗ ПРОВЕРКИ';
			MenuPath: 'Правка\Вставить из буфера обмена без ПРОВЕРКИ';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
		( Command: cmLineClear;
			Name: 'LINECLEAR';
			Hint: 'Очистка карты для линейных объектов';
			MenuPath: 'Сервис\Программы\Очистка карты для линейных объектов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0)
      ,
		( Command: cmToLinear;
			Name: 'TOLINEAR';
			Hint: 'Преобразование площадных контуров в линейные';
			MenuPath: 'Сервис\Программы\Преобразование площадных контуров в линейные';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
 		( Command: cmFastSelect;
			Name: 'FASTSELECT';
			Hint: 'Выделить все объекты такого же стиля что и выделенные ';
			MenuPath: 'Анализ\Выделить все объекты такого же стиля что и выделенные';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
 		( Command: cmFastSelect2;
			Name: 'FASTSELECT2';
			Hint: 'Выделить все объекты такого же стиля что и выделенные вписанные в окно ';
			MenuPath: 'Анализ\Выделить все объекты такого же стиля что и выделенные вписанные в окно';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
      ( Command: cmCloseAll;
			Name: 'CLOSEALL';
			Hint: 'Замкнуть все выделенные объекты';
			MenuPath: 'Правка\Замкнуть все выделенные объекты';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
 		( Command: cmUnCloseAll;
			Name: 'UNCLOSEALL';
			Hint: 'Убрать замыкание всех выделенных объектов';
			MenuPath: 'Правка\Убрать замыкание всех выделенных объектов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
 		( Command: cmLineConnect2;
			Name: 'LINECONNECT2';
			Hint: 'Соединить выделенные линии';
			MenuPath: 'Правка\Соединить выделенные линии';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
 		( Command: cmVectorRotate;
			Name: 'VECTORROTATE';
			Hint: 'Поворот векторов';
			MenuPath: 'Правка\Поворот векторов';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
 		( Command: cmDBExtractor;
			Name: 'DBEXTRACTOR';
			Hint: 'Извлечение данных из битой базы';
			MenuPath: 'Сервис\Программы\Извлечение данных из битой базы';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
  		( Command: cmMakeCircle;
			Name: 'MAKECIRCLE';
			Hint: 'Сделать из точки кружочек';
			MenuPath: 'Сервис\Программы\Сделать из точки кружочек';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
  		( Command: cmCreateZone;
			Name: 'CREATEZONE';
			Hint: 'Создание зоны вокруг';
			MenuPath: 'Сервис\Программы\Создание зоны';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
  		( Command: cmDeleteNear;
			Name: 'DELETENEAR';
			Hint: 'Удаление близкорасположенных точек';
			MenuPath: 'Правка\Удаление близкорасположенных точек';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
  		( Command: cmObjectSelect;
			Name: 'OBJECTSELECT';
			Hint: 'Выбор объектов по параметрам...';
			MenuPath: 'Анализ\Выбор объектов по параметрам...';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
  		( Command: cmCopyByStyle;
			Name: 'COPYBYSTYLE';
			Hint: 'Копирование по стилю...';
			MenuPath: 'Анализ\Копирование по стилю...';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
  		( Command: cmSetPointsSmart;
			Name: 'SETPOINTSSMART';
			Hint: 'Нумерация точек умная...';
			MenuPath: 'Правка\Нумерация точек умная...';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
  		( Command: cmLayoutFindReplace;
			Name: 'LAYOUTFINDREPLACE';
			Hint: 'Поиск замена в шаблонах...';
			MenuPath: 'Файл\Массовая правка шаблонов...';
			MenuShortCut: 0;
			ToolbarName: '';
			ToolbarGroup: '';
			Bitmap: 0),
      ( Command: cmZasechka;
			Name: 'ZASECHKA';
			Hint: 'Линейная засечка...';
			MenuPath: 'Правка\Линейная засечка...';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0),
       ( Command: cmLineConnect3;
			Name: 'LINECONNECT3';
			Hint: 'Соединение линий 3...';
			MenuPath: 'Правка\Соединить все линии 3...';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0)  ,
       ( Command: cmOkrugl2;
			Name: 'OKRUGL2';
			Hint: 'Улучшенное округление...';
			MenuPath: 'Сервис\Программы\Улучшенное округление';
			MenuShortCut: 0;
			ToolbarName: 'Утилиты Az Soft (топо3)';
			ToolbarGroup: 'Утилиты Az Soft (топо3)';
			Bitmap: 0)



	);

procedure TFAd.CloseAll;
begin
  cntrcloser.CloseAll(gAddon2);
end;

constructor TFAd.Create;
var
	i: Integer;
begin
        PacketMode:=False;
	inherited Create(CLSID_First, 'TOPOUTILS', 'разные утилиты', 0);
	for i := Low(kMacros) to High(kMacros) do
		if kMacros[i].ToolbarName <> '' then
			kMacros[i].Bitmap := LoadBitmap(hInstance, PChar(AnsiUpperCase(kMacros[i].Name)));
//        gAddon2:=TIngeoApplication.Create(nil);
end;

destructor TFAd.Destroy;
var
	i: Integer;
begin
	for i := Low(kMacros) to High(kMacros) do
		if kMacros[i].Bitmap <> 0 then
			DeleteObject(kMacros[i].Bitmap);
	inherited Destroy;

end;

function TFAd.GetMacroList: IM2MacroAttrsList;
var
	aList: TM2MacroAttrsList;
	i: Integer;
begin
	aList.OleObject := inherited GetMacroList;
	for i := Low(kMacros) to High(kMacros) do
		aList.Add(kMacros[i]);
	Result := aList.OleObject;
  gAddon2:= gAddon.AddonManager.OleObject as IIngeoApplication;
  EventConnect;
end;

function TFAd.GetBitmap(const aStm: IStream; aBitmap: Longint): Boolean;
begin
	Result := aBitmap <> 0;
	if Result then
		SaveBitmapToIStream(aBitmap, aStm);
end;

procedure TFAd.ExecuteMacro(aCmd: Longint; const aParams: TM2String);
begin
	case aCmd of
		cmActivate:
			Activate;
		cmActivate2:
			Activate2;
		cmNavigator:
			StartNavigator;
		cmTransformator:
			StartTransformator;
		cmDivider:
			StartDivider;
		cmVedomost:
			StartVedomost;
		cmFastPlan:
			StartFastPlan;
		cmSplitter:
			StartSplitter;
		cmCoordConverter:
			StartCoordConverter;
		cmErrorSearch:
			StartErrorSearch;
		cmDecurve:
			StartDeCurve;
		cmSpecSemCopy:
			StartSpecSemCopy;
		cmPodt:
			StartPodt;
		cmOverSearch:
			StartOverSearch;
		cmOkrugl:
			StartOkrugl;
    cmTest:
      Test;
    cmEGRZPoint:
      StartEGRZPoints;
    cmTHMaker:
      StartTHMaker;
    cmSemTest:
      StartSemTest;
    cmTabImport:
      StartTABImport;
    cmCSVExport:
      StartCSVExport;
    cmClearZPoints:
      StartClearZPoints;
    cmOrientContour:
      StartOrientContour;
    cmQuickPlan:
      StartQuickPlan;
    cmLinZasechka:
      StartLinZasechka;
    cmPolygonCreator:
      StartPolygon;
    cmLineConnect:
      StartLineConnect;
    cmRasterChange:
      StartRasterChange;
    cmCoordSystem:
      StartCoordSystem;
    cmContactDrawer:
      StartContactDrawer;
    cmPinDrawer:
      StartPinDrawer;
    cmSemiPinDrawer:
      StartSemiPinDrawer;
    cmLineText:
      StartLineText;
    cmCopyWindow:
      CopyWindow;
    cmPasteWindow:
      PasteWindow;
    cmPasteWindowNoCheck:
      PasteWindowNoCheck;
    cmToLinear:
      ToLinear;
    cmFastSelect:
      FastSelect(gAddon2);
    cmFastSelect2:
      FastSelect2(gAddon2);

    cmCloseAll:
      CloseAll;
    cmUnCloseAll:
      UnCloseAll;
    cmLineConnect2:
      lineconnect2.LineConnect(gAddon2);
    cmVectorRotate:
      StartVectorRotate(gAddon2);
    cmDBExtractor:
      StartDBExtractor;
    cmMakeCircle:
      StartMakeCircle(gAddon2);
    cmCreateZone:
      StartCreateZone(gAddon2);
    cmDeleteNear:
      StartDeleteNear(gAddon2);
    cmObjectSelect:
      StartObjSelect(gAddon2);
    cmCopyByStyle:
      StartCopyByStyle(gAddon2);
    cmSetPointsSmart:
      StartSmartPoint;
    cmLayoutFindReplace:
      StartLayoutFindReplace(gAddon2);

    cmZasechka:
      MakeZasechka(gAddon2);
    cmLineConnect3:
      LineConnect3(gAddon2);
    cmOkrugl2:
      Okrugl2;
	end;
end;

procedure TFad.StartDBExtractor;
var f:TFDbExtractor;
begin
  f:=TfDBExtractor.Create(nil);
  f.app:=gAddon2;
  f.ShowModal;
  f.Free;
end;

procedure TFAd.Activate;
var c:integer;
begin
  ShowFrm;
end;


function MStrToFloat(s:string):extended;
begin
  s:=AnsiReplaceStr(s,'.',',');
  Result:=StrToFloat(s);
end;

function MTryStrToFloat(s:string;var e:extended):boolean;
begin
  s:=AnsiReplaceStr(s,'.',',');
  Result:=TryStrToFloat(s,e);
end;

procedure TFAd.Activate2;
var f:TfKatExport;
begin
  f:=TfKatExport.Create(nil);
  f.ShowModal;
  f.Free;
end;

procedure TFAd.StartNavigator;
begin
  fNavigator:=TfNavigator.Create(nil);
  fNavigator.Show;
end;

procedure TFAd.StartTABImport;
var f:TfTabImport;
begin
  f:=TfTabImport.Create(nil);
  f.Show;
end;

procedure TFAd.StartTHMaker;
var f:tfTHMaker;
begin
  f:=tfTHMaker.Create(nil);
  f.Show;
end;

procedure TFAd.StartTransformator;
begin
  fTransformator:=TfTransformator.Create(nil);
  fTransformator.Show;
end;

procedure TFAd.Notify(AnAdvise: TM2Notify; const AParams: IM2ParamsList);
begin
  inherited;

end;

procedure TFAd.Okrugl2;
var z:TfOkruglForm2;
begin
  z:=TfOkruglForm2.Create(nil);
  z.app:=gAddon2;
  z.ShowModal;
  z.Free;
end;

procedure TFAd.StartDivider;
begin
  fDivider:=TfDivider.Create(nil);
  fDivider.Show;
end;

procedure TFAd.StartVedomost;
begin
  if fVedomost=nil then
  begin
    fVedomost:=TfVedomost.Create(nil);
    fVedomost.Show;
  end;
end;

procedure TFAd.StartFastPlan;
var ilw:IInLayoutWindow;
    params:OLEVariant;
    v,w,f:variant;
    i:integer;
    zs,x1,x2,y1,y2,lw,lh:double;
    mobj:IIngeoMapObject;
begin
  if gAddon2.Selection.Count=0 then exit;
  mobj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[0]);
  x1:=mobj.X1; y1:=mobj.Y1;
  x2:=mobj.X2; y2:=mobj.Y2;
  for i:=1 to gAddon2.Selection.Count-1 do
  begin
    mobj:=gAddon2.ActiveDb.MapObjects.GetObject(gAddon2.Selection.IDs[i]);
    if mobj.X1<x1 then x1:=mobj.X1;
    if mobj.Y1<y1 then y1:=mobj.Y1;
    if mobj.X2>x2 then x2:=mobj.X2;
    if mobj.Y2>y2 then y2:=mobj.Y2;
  end;
  zs:=gAddon2.MainWindow.MapWindow.Surface.Projection.ZoomScale;
  lw:=(y2-y1)*zs*1.02;
  lh:=(x2-x1)*zs*1.02;

  params:=1;
  v:=Gaddon2;

  w:=v.OpenWindow('LayoutWindow');
  f:=w.Figures.Add(100);

  f.Left:=0.02;
  f.Width:=lw;
  f.Height:=lh;
  f.Bottom:=0.02;
  f.CenterX:=(x1+x2)/2;
  f.CenterY:=(y1+y2)/2;
  w.PrintParams.PageSizeX:=lw+0.04;
  w.PrintParams.PageSizeY:=lh+0.04;
end;

procedure TFAd.StartLineConnect;
begin
  MakeLineConnect;
end;

procedure TFAd.StartLineText;
var f:TfLineText;
begin
  f:=TfLineText.Create(nil);
  f.Show;
end;

procedure TFAd.StartLinZasechka;
var f:TfLinZasechka;
begin
  f:=TfLinZasechka.Create(nil);
  f.Show;
end;

procedure TFAd.StartSplitter;
begin
  fSplitter:=TfSplitter.Create(nil);
  fSplitter.Show;
end;

procedure TFAd.StartClearZPoints;
var f:TfClearZPoints;
begin
  f:=tfClearZPoints.Create(nil);
  f.ShowModal;
  f.Free;
end;

procedure TFAd.StartContactDrawer;
var f:TfContactDrawer;
begin
  f:=TfContactDrawer.Create(nil);
  f.Show;
end;

procedure TFAd.StartCoordConverter;
begin
  fCoordConverter:=TfCoordConverter.Create(nil);
  fCoordConverter.Show;
end;

procedure TFAd.StartCoordSystem;
var f:TfCoordSystem;
begin
  f:=TfCoordSystem.Create(nil);
  f.ShowModal;
  f.Free;
end;

procedure TFAd.StartCSVExport;
var f:TfCSVExport;
begin
  f:=TfCSVExport.Create(nil);
  f.ShowModal;
  f.Free;
end;

procedure TFAd.StartErrorSearch;
begin
  fErrorSearch:=TfErrorSearch.Create(nil);
  fErrorSearch.Show;
end;

procedure TFAd.StartDeCurve;
var f:TfDeCurve;
begin
  f:=TfDeCurve.Create(nil);
  f.Show;
end;

procedure TFAd.StartSemiPinDrawer;
var f:TfSemiPinDrawer;
begin
  f:=TfSemiPinDrawer.Create(nil);
  f.Show;
end;

procedure TFAd.StartSemTest;
var f:TfSemTest;
begin
  f:=TfSemTest.Create(nil);
  f.ShowModal;
  f.Free;
end;

procedure TFAd.StartSmartPoint;
var f:TfSmartPointMaker;
begin
  f:=TfSmartPointMaker.Create(nil);
  f.app:=gAddon2;
  f.ShowModal;
  f.Free;
end;

procedure TFAd.StartSpecSemCopy;
var f:TfSpecSemCopy;
begin
  f:=TfSpecSemCopy.Create(nil);
  f.Show;
end;

procedure TFAd.StartPinDrawer;
var f:TfPins;
begin
  f:=TfPins.Create(nil);
  f.Show;
end;

procedure TFAd.StartPodt;
var f:TfPodt;
begin
  f:=TfPodt.Create(nil);
  f.Show;
end;

procedure TFAd.StartPolygon;
var f:TfPolygonCreator;
begin
  f:=TfPolygonCreator.Create(nil);
  f.Show;
end;

procedure TFAd.StartQuickPlan;
var f:TfQuickPlan;
begin
  f:=TfQuickPlan.Create(nil);
  f.Show;
end;

procedure TFAd.StartRasterChange;
var f:TfRasterChange;
begin
  f:=TfRasterChange.Create(nil);
  f.ShowModal;
  f.Free;
end;

procedure TFAd.StartOverSearch;
var f:TfOverSearch;
begin
  f:=TfOverSearch.Create(nil);
  f.Show;

end;

procedure TFAd.StartOkrugl;
var f:TfOkrugl;
begin
  f:=TfOkrugl.Create(nil);
  f.Show;
end;

procedure TFAd.StartOrientContour;
var f:TfContourOrient;
begin
  f:=TfContourOrient.Create(nil);
  f.Show;
end;

procedure TFAd.Test;
var f:Tftest;
begin
  f:=TfTest.Create(nil);
  f.Show;
end;

procedure TFAd.ToLinear;
var
  but: Integer;
begin
  but:= MessageDlg('Выделенные объекты будут преобразованы в линейные',
  mtConfirmation,mbYesNo,0);
  if but=mrYes	 then
  begin
    StartToLinear;
  end;

  
end;

procedure TFAd.UnCloseAll;
begin
  cntrcloser.UnCloseAll(gAddon2);
end;

procedure TFAd.StartEGRZPoints;
var f:TfEGRZPoint;
begin
  f:=TfEGRZPoint.Create(nil);
  f.Show;
end;

function GetStyleName(stl:string):string;
begin
  if gAddon2.ActiveDb.StyleExists(stl) then
  begin
    Result:=gAddon2.ActiveDb.StyleFromID(stl).Layer.Name+'\'+
            gAddon2.ActiveDb.StyleFromID(stl).Name;
  end else Result:='';
end;

function GetStyleNameID(stl:string):string;
begin
  if gAddon2.ActiveDb.StyleExists(stl) then
  begin
    Result:='['+stl+']'+ gAddon2.ActiveDb.StyleFromID(stl).Layer.Name+'\'+
            gAddon2.ActiveDb.StyleFromID(stl).Name;
  end else Result:='';
end;

procedure TFAd.EventConnect;
var r:TMyDrawEventSink;
    cp:IConnectionPoint;
begin
//  r:=TMyDrawEventSink.Create;
//  cp:=nil;
//  cp:=gAddon.AddonManager.OleObject as IConnectionPoint;
//  if cp=nil then ShowMessage('Not inter!');
//  cp.Advise(r,ecvalue)
//  InterfaceConnect(gAddon2,IID_IIngeoApplication,r,ecvalue);
end;
function GetLayerName(lar:string):string;
begin
  if gAddon2.ActiveDb.LayerExists(lar) then
    Result:=gAddon2.ActiveDb.LayerFromID(lar).Map.Name+'\'+gAddon2.ActiveDb.LayerFromID(lar).Name
    else Result:='';
end;

initialization
	gAddon := TFAd.Create;
finalization
	gAddon.Free;
end.
