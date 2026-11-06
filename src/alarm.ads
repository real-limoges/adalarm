package Alarm with
  Pure
is

   type State is (Idle, Ringing, Snoozed, Suppressed_Calendar);

   type Event is
     (Alarm_Fires, Button_Snooze, Button_Dismiss, Snooze_Expires,
      Calendar_Busy, Calendar_Clears);

   Max_Snoozes : constant := 3;
   subtype Snooze_Count is Natural range 0 .. Max_Snoozes;

   type Clock is private;

   function Current (C : Clock) return State;
   function Snoozes (C : Clock) return Snooze_Count;

   function Silent (C : Clock) return Boolean is (Current (C) /= Ringing);

   function Reset return Clock with
     Post => Current (Reset'Result) = Idle and Snoozes (Reset'Result) = 0;

   procedure Handle (C : in out Clock; E : Event) with
     Post =>
      Snoozes (C) <= Max_Snoozes
      and then
      (Snoozes (C) = Snoozes (C)'Old or else Snoozes (C) = Snoozes (C)'Old + 1
       or else Snoozes (C) = 0)
      and then
      (if Current (C) = Snoozed and then Current (C)'Old = Ringing then
         Snoozes (C) = Snoozes (C)'Old + 1);

private

   type Clock is record
      Now  : State        := Idle;
      Used : Snooze_Count := 0;
   end record with
     Type_Invariant => (if Clock.Now = Idle then Clock.Used = 0);

end Alarm;
