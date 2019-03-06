#include "slick.sh"

/**
 * Check if an associated file exists in the current directory.
 *
 * @param filename      current buffer name
 * @param ext_list      list of alternate file extensions to try
 *
 * @return boolean
 */
static boolean associated_file_exists(_str &filename, _str ext_list)
{
   mou_hour_glass(true);
   filename_no_ext  := _strip_filename(filename, 'E');
   filename_no_path := _strip_filename(filename, 'EP');

   // try same directory
   foreach (auto ext in ext_list) {
      if (file_exists(filename_no_ext :+ ext)) {
         filename = filename_no_ext :+ ext;
         mou_hour_glass(false);
         return true;
      }
   }

   // try current project
   if (_project_name != '') {
      foreach (ext in ext_list) {
         message("Searching: "_project_name);
         filename_in_project := _projectFindFile(_workspace_filename, _project_name, filename_no_path :+ ext, 0);
         if (filename_in_project != '') {
            filename = filename_in_project;
            mou_hour_glass(false);
            return true;
         }
      }
   }

   // try entire workspace
   if (_workspace_filename != '') {
      _str foundFileList[];
      _str projectList[] = null;
      _GetWorkspaceFiles(_workspace_filename, projectList);
      foreach (ext in ext_list) {

         // try all projects in the workspace
         foreach (auto project in projectList) {
            project = _AbsoluteToWorkspace(project, _workspace_filename);
            if (project != _project_name) {
               // search this project for the file
               message("Searching: "project);
               filename_in_project := _projectFindFile(_workspace_filename, project, filename_no_path :+ ext, 0);
               if (filename_in_project != "") {
                  foundFileList[foundFileList._length()] = filename_in_project;
               }
            }

         }
      }

      // remove duplicates
      foundFileList._sort();
      _aremove_duplicates(foundFileList, file_eq("A",'a'));

      // exactly one match, super!
      if (foundFileList._length() == 1) {
         filename = foundFileList[0];
         mou_hour_glass(false);
         return true;
      }

      // multiple matches, prompt
      if (foundFileList._length() > 1) {
         answer := select_tree(foundFileList);
         if (answer != '' && answer != COMMAND_CANCELLED_RC) {
            filename = answer;
            mou_hour_glass(false);
            return true;
         }
      }
   }

   // that's all folks
   mou_hour_glass(false);
   return false;
}

static _str project_home_path() {
  _str project = _project_get_filename();
  int k = pos("lib", project);
  if (!k) {
    k = pos("app", project);
  }
  return substr(project, 1, k - 1);
}

static _str test_file_for(_str filename)
{
  int i = pos("lib", filename);
  if (i) {
    int j = pos(".", filename);
    _str test_file = project_home_path() :+ "tests/" :+ substr(filename, i, j - i) :+ "_test.cpp";
    return test_file;
  }
  i = pos("include", filename);
  if (i) {
    int j = pos(".", filename);
    _str test_file = project_home_path() :+ "tests/lib" :+ 
      substr(filename, i + 7, j - (i + 7)) :+ "_test.cpp";
    return test_file;
  }
  i = pos("app", filename);
  if (i) {
    int j = pos(".", filename);
    _str test_file = project_home_path() :+ "tests/" :+ substr(filename, i, j - i) :+ "_test.cpp";
    return test_file;
  }
  return "";
}

_command void edit_test_file() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_MDI)
{
   _str filename = test_file_for(p_buf_name);
   auto i = pos("_test.cpp", p_buf_name);
   if (i) {
     auto j = pos("lib", p_buf_name);
     if (!j) {
       j = pos("app", p_buf_name);
     }
     filename = project_home_path() :+ substr(p_buf_name, j, i - j) :+ ".cpp";
   }
   message(filename);

   // edit the file
   if (filename != "") {
      edit(maybe_quote_filename(filename),EDIT_DEFAULT_FLAGS);
   } else {
      message("No match found");
   }
}

_command void edit_counterpart() name_info(','VSARG2_READ_ONLY|VSARG2_REQUIRES_EDITORCTL|VSARG2_REQUIRES_MDI)
{
  int index = pos("_test", p_buf_name);
  if (!index) {
    edit_associated_file();
  } else {
    edit_test_file();
  }
}

