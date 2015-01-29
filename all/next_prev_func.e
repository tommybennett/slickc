#include "slick.sh"

int function_has_comment() {
  _str line;
  cursor_up();
  get_line( line );
  if ( pos('^[/\* ][/\*].*', line, 1, 'U' ) ) {
    cursor_down();
    return 1;
  }

  cursor_down();
  return 0;
}

void move_to_beginning_of_comment() {
  if ( function_has_comment() ) {
    int n;
    n = p_RLine;
    if ( find('^/', 'U-') == 0 ) {
      line_to_top(); 
      cursor_down(n - p_RLine);
    }
  } else { 
    line_to_top();
    cursor_down();
    cursor_up();
  }
}

_command void next_func()
{
   if ( next_proc() == 0 )
     move_to_beginning_of_comment();
}

_command void prev_func()
{
   if ( prev_proc() == 0 )
     move_to_beginning_of_comment();
}
