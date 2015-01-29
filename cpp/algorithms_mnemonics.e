#include "slick.sh"

struct algorithm {
  _str name;
  _str description;
};

defeventtab algorithms;
ctlok.lbutton_up()
{
  int indices[];
  ctltree._TreeGetSelectionIndices(indices);
  if (indices._length()) {
    _param1 = ctltree._TreeGetCaption(indices[0]);
  }

  p_active_form._delete_window(_param1);
}

static _str nonmodifying[]={
  "fre for_each",
  "cnt count",
  "cni count_if",
  "mne min_element",
  "mxe max_element",
  "mme minmax_element",
  "fnd find",
  "fni find_if",
  "fin find_if_not",
  "fne find_end",
  "srh search",
  "srn search_n",
  "ffo find_first_of",
  "ajf adjacent_find",
  "eql equal",
  "ipr is_permutation",
  "msm mismatch",
  "iss is_sorted",
  "isu is_sorted_until",
  "ipt is_partitioned",
  "ppt partition_point",
  "ihp is_heap",
  "ihu is_heap_until",
  "alo all_of",
  "ano any_of",
  "nno none_of",
  "lxc lexicographical_compare"
};

static _str sorting[]={
  "srt sort",
  "sts stable_sort",
  "pst partial_sort",
  "psc partial_sort_copy",
  "nth nth_element",
  "ptn partition",
  "spt stable_partition",
  "ptc partition_copy",
  "mkh make_heap",
  "phh push_heap",
  "pph pop_heap",
  "sth sort_heap"
};

static _str sorted_ranges[]={
  "bns binary_search",
  "inc includes",
  "lwb lower_bound",
  "upb upper_bound",
  "eqr equal_range",
  "mrg merge",
  "stu set_union",
  "sti set_intersection",
  "std set_difference",
  "ssd set_symmetric_difference",
  "ipm inplace_merge",
  "ucp unique_copy" 
};

static _str modifying[] = {
  "cpy copy",
  "cpi copy_if",
  "cpn copy_n",
  "cpb copy_backward",
  "mov move",
  "mvb move_backward",
  "tfm transform",
  "mrg merge",
  "swr swap_ranges",
  "fil fill",
  "fln fill_n",
  "gnr generate",
  "gnn generate_n",
  "rpl replace",
  "rpi replace_if",
  "rpc replace_copy",
  "rci replace_copy_if",
  "ita iota"
};

static _str removing[] = {
  "rmv remove",
  "rmi remove_if",
  "rmc remove_copy",
  "rmf remove_copy_if",
  "uqe unique",
  "ucp unique_copy"
};

static _str mutating[] = {
  "rvr reverse",
  "rvc reverse_copy",
  "rte rotate",
  "rtc rotate_copy",
  "nxp next_permutation",
  "prp prev_permutation",
  "shf random_shuffle"
};

static algorithm numeric[] = {
  {"acm accumulate", "Accumulate"}
};

static _str string_algorithms[] = {
  "upr uppercase",
  "lwr lowercase",
  "ltr left trim",
  "trm right trim"
};

defeventtab algorithms;
ctltree.on_create()
{
  flag=TREE_ADD_AS_CHILD;

  c=prev=_TreeAddItem(0, "Nonmodifying Algorithms", TREE_ADD_AS_CHILD,
                      _pic_fldclos, _pic_fldaop, 0);

  for (i=0;i<nonmodifying._length();i++) {
    _TreeAddItem(c,nonmodifying[i], TREE_ADD_AS_CHILD, _pic_file, _pic_file,-1);
  }

  c=prev=_TreeAddItem(0, "Sorting Algorithms", TREE_ADD_AS_CHILD,
                      _pic_fldclos, _pic_fldaop, 0);

  for (i=0;i<sorting._length();i++) {
    _TreeAddItem(c,sorting[i], TREE_ADD_AS_CHILD, _pic_file, _pic_file,-1);
  }

  c=prev=_TreeAddItem(0, "Modifying Algorithms", TREE_ADD_AS_CHILD,
                      _pic_fldclos, _pic_fldaop, 0);

  for (i=0;i<modifying._length();i++) {
    _TreeAddItem(c,modifying[i], TREE_ADD_AS_CHILD, _pic_file, _pic_file,-1);
  }

  c=prev=_TreeAddItem(0, "Removing Algorithms", TREE_ADD_AS_CHILD,
                      _pic_fldclos, _pic_fldaop, 0);

  for (i=0;i<removing._length();i++) {
    _TreeAddItem(c,removing[i], TREE_ADD_AS_CHILD, _pic_file, _pic_file,-1);
  }

  c=prev=_TreeAddItem(0, "Mutating Algorithms", TREE_ADD_AS_CHILD,
                      _pic_fldclos, _pic_fldaop, 0);

  for (i=0;i<mutating._length();i++) {
    _TreeAddItem(c,mutating[i], TREE_ADD_AS_CHILD, _pic_file, _pic_file,-1);
  }

  c=prev=_TreeAddItem(0, "Numeric Algorithms", TREE_ADD_AS_CHILD,
                      _pic_fldclos, _pic_fldaop, 0);

  for (i=0;i<numeric._length();i++) {
    j=_TreeAddItem(c,numeric[i].name, TREE_ADD_AS_CHILD, _pic_file, _pic_file,1);
    _TreeSetUserInfo(j,numeric[i].description);
  }

  c=prev=_TreeAddItem(0, "String Algorithms", TREE_ADD_AS_CHILD,
                      _pic_fldclos, _pic_fldaop, 0);

  for (i=0;i<string_algorithms._length();i++) {
    _TreeAddItem(c,string_algorithms[i], TREE_ADD_AS_CHILD, _pic_file, _pic_file,1);
  }
}

ctltree.on_change(int reason, int index)
{
  int indices[];
  ctltree._TreeGetSelectionIndices(indices);
  if (indices._length()) {
    ctldescription.p_caption = _TreeGetUserInfo(indices[0]);
  }
}

_command show_algorithms() 
{
  result = show( "-modal algorithms");
  if (result=="") {
    return COMMAND_CANCELLED_RC; 
  }

  strip_last_word(_param1);
  sw(_param1);
}

_command sw(_str abbrev="")
{
  if ( _isnull_selection() ) {
    prev_word(); 
    select_word();
  }

  if (surround_with(abbrev)==0) {
    typeless p;
    save_pos(p);
    top_of_buffer();
    replace("){", ") {", "*");
    restore_pos(p);
    message("Surround with completed");
  } else {
    message("No surround with defined for "abbrev);
    deselect();
  }
}
