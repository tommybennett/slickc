#include "slick.sh"

static _str get_class_name() {
  class_name = current_class(false);
  class_name = substr(class_name, pos('/', class_name) + 1);
  int n = pos(':', class_name);
  if ( n > 0 ) {
    class_name = substr(class_name, 1, n) :+ ":" :+ substr(class_name, n + 1); 
  }

  return class_name;
}

static void create_member_function(_str text) {
  _str class_name;

  int interface_file = 0;
  if ( !strcmp(_get_extension(p_buf_name), 'h') )
    interface_file = 1;


  if (interface_file) {
    edit_counterpart(); 
    bottom_of_buffer();
    find('^}', 'U-');
  } else {
    find('^}', 'U');
    cursor_down('2');
  }

  _insert_text(text);
  beautify(true);

  if (interface_file)
    edit_counterpart(); 
}

_command void create_dctr()
{
  _str class_name;
  class_name = get_class_name();  
  create_member_function("\n" class_name "::" class_name "() {\n}\n\n");
}

_command void create_cctr()
{
  _str class_name;
  class_name = get_class_name();  
  create_member_function(class_name "::" class_name "( const " class_name "& rhs ) {\n}\n\n");
}

_command void create_assignment_operator()
{
  _str text;
  _str class_name;
  class_name = get_class_name();  
  
  text = class_name "& " class_name "::operator =( const " class_name "& rhs ) {\n";
  text = text :+ "  " class_name " temp( rhs );  // do all work off to the side\n";
  text = text :+ "  Swap( temp );             // then ""commit"" the work using\n";
  text = text :+ "  return *this;             //  nonthrowing operations only\n";
  text = text :+ "}\n\n";
   
  text = text :+ "void " class_name "::Swap( " class_name "& other ) {\n";
  text = text :+ "  unique_ptr<impl> temp( impl_ );\n";
  text = text :+ "  impl_ = other.impl_;\n";
  text = text :+ "  other.impl_ = temp;\n";
  text = text :+ "}\n\n";

  create_member_function(text);
}

_command void create_ddtr()
{
  _str class_name;
  class_name = get_class_name();  
  create_member_function(class_name "::~" class_name "() {\n}\n\n");
}

_command void create_init()
{
  _str class_name;
  class_name = get_class_name();
  create_member_function("void " class_name "::init( const " class_name "& other ) {\n}\n\n");
}

_command void create_pimpl()
{
  _str class_name;
  class_name = get_class_name();

  edit_counterpart(); 
  
  top_of_buffer();
  find('^namespace', 'U');
  cursor_down();

  _insert_text("\nclass " class_name "::impl {\n};\n" ); 

  edit_counterpart();
}

