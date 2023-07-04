class singleton_class;
  
  static protected singleton_class m_self;
  protected function new(string name = "singleton_class");
    super.new(name);
  endfunction

  static function singleton_class get_inst();
      if (m_self == null) begin
         m_self = new("singleton_class");
      end
      return m_self;
   endfunction

endclass
