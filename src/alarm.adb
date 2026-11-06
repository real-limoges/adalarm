package body Alarm is

   function Reset return Clock is ((Now => Idle, Used => 0));
   function Current (C : Clock) return State is (C.Now);
   function Snoozes (C : Clock) return Snooze_Count is (C.Used);

   function Snooze_Available (C : Clock) return Boolean is
     (C.Used < Max_Snoozes);

   procedure Handle (C : in out Clock; E : Event) is
   begin
      case C.Now is

         when Idle =>
            if E = Alarm_Fires then
               C := (Now => Ringing, Used => 0);
            elsif E = Calendar_Busy then
               C.Now := Suppressed_Calendar;
            end if;

         when Ringing =>
            case E is
               when Button_Snooze =>
                  if Snooze_Available (C) then
                     C.Used := C.Used + 1;
                     C.Now  := Snoozed;
                  end if;
               when Button_Dismiss =>
                  C := Reset;
               when others =>
                  null;
            end case;

         when Snoozed =>
            case E is
               when Snooze_Expires =>
                  C.Now := Ringing;
               when Button_Dismiss =>
                  C := Reset;
               when others =>
                  null;
            end case;

         when Suppressed_Calendar =>
            if E = Calendar_Clears then
               C := Reset;
            end if;

      end case;
   end Handle;

end Alarm;
