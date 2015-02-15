#include "slick.sh"

defeventtab newClassForm
ctlok.lbutton_up()
{
  _param1 = ctllist._lbget_seltext();
  _param2 = ctlclassname.p_text;
  _param3 = ctlnamespace.p_text;
  _param4 = ctldirectory.p_text;
  p_active_form._delete_window(_param1);
}

ctllist.on_create()
{
  // load templates from ~/etc/cpp-template or based on project type
  // Could also load project specific templates located in local
  // template directory.

  _str name = "/Users/tommy/etc/cpp-template/*.h";
  _str filename = f_match(name, true);
  while ( filename != "" ) {
    _lbadd_item(_strip_filename(filename, "PE"));
    filename = f_match(name, false);
  }

  _lbsort();
  _lbtop();
  _lbselect_line();
}

static _str camel2snake(_str word)
{
  _str output = "";
  boolean last_was_upper = false;
  for ( i = 1; i <= length(word); i++ ) {
    _str ch = substr(word, i, 1);
    if (isupper(ch)) {
      ch = lowcase(ch);
      if (length(output) && !last_was_upper) {
        output = output :+ "_" :+ ch; 
      } else {
        output = output :+ ch; 
      }
      last_was_upper = true;
    } else {
      last_was_upper = false;
      output = output :+ ch; 
    }
  }

  return output;
}

_command new_class() name_info(',')
{
  result = show( "-modal newClassForm");
  if (result=="") {
    return COMMAND_CANCELLED_RC; 
  }

  if (!length(_param1)) {
    _message_box("Please select a template name.");
  } else if (!length(_param2)) {
    _message_box("Please provide a class name."); 
  } else if (!length(_param3)) {
    _message_box("Please provide a namespace."); 
  } else if (!length(_param4)) {
    _message_box("Please provide a directory."); 
  } else {
    // Execute the command to create the files.
    _str command;
    if ( strcmp(_param1, "basic_module") == 0 )
      command = "/Users/tommy/bin/mkmodule "_param4" "_param3" "_param2; 
    else
      command = "/Users/tommy/bin/mkclass -t "_param1" "_param4" "_param3" "_param2;

    shell( command, "Q" );

    // Are we creating an app module or library module?
    boolean app_module = pos("app/", _param4) != 0;

    // Get the header filename, filename, and test filename.
    _str filename = camel2snake(_param2); 
    int index = pos('/',_param4);
    _str modulename = substr(_param4,index+1);
    _str header = "include/"modulename"/"filename".h";
    if (app_module) {
      header = "app/"modulename"/"filename".h";
    }
    _str impl = _param4"/"filename".cpp"; 
    _str testfile = "tests/"_param4"/"filename"_test.cpp";

    // Add files to the project.
    _str project_file = absolute(_param4"/"modulename".vpj");
    project_add_file(header, false, project_file); 
    project_add_file(impl, false, project_file); 
    project_add_file(testfile, false, project_file); 
    _clearWorkspaceFileListCache();
    workspace_refresh(); 

    // Load header file
    edit(header);
  }
}
