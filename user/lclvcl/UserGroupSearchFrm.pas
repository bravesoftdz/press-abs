(*
  AbstractClasses, Authentication and Authorization, Group Search Form
  Copyright (C) 2010 Jitec Software

  http://www.jitec.com.br

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit UserGroupSearchFrm;

{$I abs.inc}

interface

uses
  CustomSearchFrm, Classes, Controls, ExtCtrls, Buttons;

type
  TUserGroupSearchForm = class(TCustomSearchForm)
  end;

implementation

uses
  PressXCLBroker, UserMVP;

{$ifdef fpc}{$R *.lfm}{$else}{$R *.dfm}{$endif}

initialization
  PressXCLForm(TUserGroupSearchPresenter, TUserGroupSearchForm);

end.
