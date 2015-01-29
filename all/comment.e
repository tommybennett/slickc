#include "slick.sh"

_command void paste_comment() name_info(',') {
  int n = p_line; 

  last_event(name2event('i'));vi_insert_mode();
  paste();
  vi_escape();
  vi_get_event('SP');
  last_event(name2event('V'));vi_toggle_line_visual();

  int m = p_line;
  while (m-- != n) {
    last_event(name2event('k'));vi_visual_select_up();
  }

  execute('reflow-selection');
  execute('box');
  last_event(name2event('v'));vi_toggle_char_visual();
  last_event(name2event('v'));vi_toggle_char_visual();

  last_event(name2event('j'));vi_next_line();
  last_event(name2event('A'));vi_end_line_append_mode();
  last_event(name2event(' '));c_space();
  vi_escape();
  last_event(name2event('0'));vi_begin_line();
}

_command void start_block_comment() name_info(',') {
  last_event(name2event('i'));vi_insert_mode();
  keyin("This");
  last_event(name2event(' '));c_space();
  keyin("is");
  last_event(name2event(' '));c_space();
  keyin("a");
  last_event(name2event(' '));c_space();
  keyin("comment");
  keyin('.');
  vi_escape();
  vi_get_event('SP');
  last_event(name2event('V'));vi_toggle_line_visual();
  execute('box');
  last_event(name2event('v'));vi_toggle_char_visual();
  last_event(name2event('v'));vi_toggle_char_visual();
  last_event(name2event('j'));vi_next_line();
  last_event(name2event('w'));vi_next_word();
  last_event(name2event('w'));vi_next_word();
  last_event(name2event('D'));vi_delete_to_end();
  last_event(name2event('i'));vi_insert_mode();
  last_event(name2event(' '));c_space();
}
