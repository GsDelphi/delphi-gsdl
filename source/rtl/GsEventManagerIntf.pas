{
  This file is part of Gilbertsoft Delphi Library (GSDL).

  Copyright (C) 2018 Simon Gilli
    Gilbertsoft | https://delphi.gilbertsoft.org

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see <https://www.gnu.org/licenses/>.
}
unit GsEventManagerIntf;

{<

  @abstract(Gilbertsoft System Utilities)
  @seealso(SecLicense License)
  @author(Simon Gilli <delphi@gilbertsoft.org>)
  @created(2017-10-06)
  @cvs($Date: 2008-06-23 01:28:42 +0200 (pon, 23 cze 2008) $)

  @name contains low level system routines.
}

{$I Gilbertsoft.inc}

interface

type
{
  @name is the representation of an event
}
  IGSEventInterface = interface(IInterface)
    ['{CFC9E153-CF8F-4A66-883D-1940F400EAA5}']
{
    /**
     * Get event name
     *
     * @return string
     */
    public function getName();

    /**
     * Get target/context from which event was triggered
     *
     * @return null|string|object
     */
    public function getTarget();

    /**
     * Get parameters passed to the event
     *
     * @return array
     */
    public function getParams();

    /**
     * Get a single parameter by name
     *
     * @param  string $name
     * @return mixed
     */
    public function getParam($name);

    /**
     * Set the event name
     *
     * @param  string $name
     * @return void
     */
    public function setName($name);

    /**
     * Set the event target
     *
     * @param  null|string|object $target
     * @return void
     */
    public function setTarget($target);

    /**
     * Set event parameters
     *
     * @param  array $params
     * @return void
     */
    public function setParams(array $params);

    /**
     * Indicate whether or not to stop propagating this event
     *
     * @param  bool $flag
     */
    public function stopPropagation($flag);

    /**
     * Has this event indicated event propagation should stop?
     *
     * @return bool
     */
    public function isPropagationStopped();
}
  end;


  { @name is the callback prototype
    @param(Sender is the EventManager object and supports the IGSEventManagerInterface interface)
    @param(Event is the triggered Event object and supports the IGSEventInterface interface)
    @returns(Hexadecimal representation of the value) }
  TGSEventManagerCallback = function(Sender, Event: TObject): Boolean;

  { @name is the callback prototype for object methods }
  TGSEventManagerObjectCallback = function(Sender, Event: TObject): Boolean of object;

  { @name is the interface for EventManager }
  IGSEventManagerInterface = interface(IInterface)
    ['{89857A91-8561-45A1-9C47-26F77D5F254F}']
    { @name attaches a listener to an event
  @param(Value is the integer or Int64 value to be converted)
  @param(Digits is the number of nibbles used for the output)
  @param(Group is the number of nibbles used for grouping)
  @returns(Hexadecimal representation of the value)
  @raises(EGSConvertError if the value could not be converted)

      @param string $event the event to attach too
      @param callable $callback a callable function
      @param int $priority the priority at which the $callback executed
      @return bool true on success false on failure }
    function Attach(const AEvent: TGUID; ACallback: TGSEventManagerCallback; APriority: Integer = 0): Boolean; overload;

    { @name attaches a listener to an event
      @param string $event the event to attach too
      @param callable $callback a callable function
      @param int $priority the priority at which the $callback executed
      @return bool true on success false on failure }
    function Attach(const AEvent: TGUID; ACallback: TGSEventManagerObjectCallback; APriority: Integer = 0): Boolean; overload;

    { @name detaches a listener from an event
      @param string $event the event to attach too
      @param callable $callback a callable function
      @return bool true on success false on failure }
    function Detach(const AEvent: TGUID; ACallback: TGSEventManagerCallback): Boolean; overload;

    { @name detaches a listener from an event
      @param string $event the event to attach too
      @param callable $callback a callable function
      @return bool true on success false on failure }
    function Detach(const AEvent: TGUID; ACallback: TGSEventManagerObjectCallback): Boolean; overload;

    { @name clears all listeners for a given event
      @param( string $event)
      @return void }
    procedure ClearListeners(const AEvent: TGUID);

    { @name triggers an event

      Can accept an EventInterface or will create one if not passed

      @param  string|EventInterface $event
      @param  object|string $target
      @param  array|object $argv
      @return mixed }
    function Trigger(AEvent: TObject): Boolean;
  end;

implementation

end.
