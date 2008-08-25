require File.dirname(__FILE__) + '/spec_helper'

describe Object, "" do
  it "should be case insensitive"
  it "should try to fix spelling mistakes"
  it "should filter unknown tokens"
  it "should be able to form questions about ambiguous examples"
  it "should be able to provide guesses about ambiguous examples"
end

describe DutchRecurringEventsParser, "parsing common examples" do
  
  def run_examples examples
    failures = []
    examples.each do |example|
      
      if example.is_a? Array
        parse_tree = @parser.parse(example.first)            
      else
        parse_tree = @parser.parse(example)
      end
      
      if parse_tree
        
        if example.is_a? Array
          if !(parse_tree.respond_to? :evaluate)
            failures << "[FAILED EVAL] \"#{example.first}\" | Eval method missing! "
          elsif parse_tree.evaluate != example.last
            
            result = parse_tree.evaluate            
            failures << "[FAILED EVAL] \"#{example.first}\" | Expected: #{example.last.inspect} | Got: #{result.inspect}"
          end
        end
        
      else
        failures << "[FAILED] \"#{example}\""
      end
    end
    
    raise failures.join("\n") if !failures.empty?    
  end
  
  before(:each) do    
    @parser = DutchRecurringEventsParser.new
  end
  
  it "should parse all examples regarding date ranges" do
    examples = [
        ["maandag",                               [ [:none],  [1]           ] ],
        ["maandag tot vrijdag",                   [ [:none],  [1,2,3,4]     ] ],
        ["ma tot vr",                             [ [:none],  [1,2,3,4]     ] ],
        ["maandag t/m vrijdag",                   [ [:none],  [1,2,3,4,5]   ] ],
        ["maandag en donderdag",                  [ [:none],  [1,4]         ] ],
        ["maandag, dinsdag en donderdag",         [ [:none],  [1,2,4]       ] ],
        ["maandag t/m donderdag en vrijdag",      [ [:none],  [1,2,3,4,5]   ] ],
        ["vrijdag en maandag t/m donderdag",      [ [:none],  [1,2,3,4,5]   ] ],
        ["maandag dinsdag donderdag en vrijdag",  [ [:none],  [1,2,4,5]     ] ],
        ["vrijdag t/m woensdag",                  [ [:none],  [0,1,2,3,5,6] ] ],
        ]

     run_examples examples
  end
  
  it "should parse all examples regarding datetime ranges" do
    examples = [
        ["maandag van 3 tot 6",                                   [ [:none],          [1]     , [Time.parse('15:00'),Time.parse('18:00')] ] ],
        ["maandag 3 tot 6",                                       [ [:none],          [1]     , [Time.parse('15:00'),Time.parse('18:00')] ] ],
        ["maandag 3 uur tot 6 uur",                               [ [:none],          [1]     , [Time.parse('15:00'),Time.parse('18:00')] ] ],
        ["maandag 10:00 tot 18:00",                               [ [:none],          [1]     , [Time.parse('10:00'),Time.parse('18:00')] ] ],
        ["maandag 1:00 tot 18:00",                                [ [:none],          [1]     , [Time.parse('01:00'),Time.parse('18:00')] ] ],
        ["maandag van tien tot twaalf 's nachts",                 [ [:none],          [1]     , [Time.parse('22:00'),Time.parse('00:00')] ] ],
        ["maandag van 1 uur 's nachts t/m 6 uur in de ochtend",   [ [:none],          [1]     , [Time.parse('01:00'),Time.parse('06:00')] ] ],
        ["maandag elke week van drie tot vijf 's middags",        [ [:every,1,:week], [1]     , [Time.parse('15:00'),Time.parse('17:00')] ] ],
        ["maandagmiddag",                                         [ [:none],          [1]     , [Time.parse('12:00'),Time.parse('18:00')] ] ],
        ["maandag-, dinsdag- en donderdagmiddag",                 [ [:none],          [1,2,4] , [Time.parse('12:00'),Time.parse('18:00')] ] ],
        ["maandag, dinsdag en donderdagmiddag",                   [ [:none],          [1,2,4] , [Time.parse('12:00'),Time.parse('18:00')] ] ],
        ["maandagmiddag t/m dinsdagmiddag",                       [ [:none],          [1,2]   , [Time.parse('12:00'),Time.parse('18:00')] ] ],
        ["maandag- t/m dinsdagmiddag",                            [ [:none],          [1,2]   , [Time.parse('15:00'),Time.parse('18:00')] ] ],
        ]

     run_examples examples 
  end
    
  it "should parse all examples regarding recurrency" do    
    examples = [
      ["elke maandag",                  [ [:every,1,:day],    [1]               ] ],
      ["iedere maandag",                [ [:every,1,:day],    [1]               ] ],
      ["op iedere maandag",             [ [:every,1,:day],    [1]               ] ],
      ["elke dag",                      [ [:every,1,:day],    [0,1,2,3,4,5,6]   ] ],
      ["iedere week",                   [ [:every,1,:week],   []                ] ],
      ["iedere maand",                  [ [:every,1,:month],  []                ] ],
      ["maandag elke week",             [ [:every,1,:week],   [1]               ] ],
      ["maandag elke twee weken",       [ [:every,2,:week],   [1]               ] ],
      ["maandag elke 3 maanden",        [ [:every,3,:month],  [1]               ] ],
      ["tweewekelijks",                 [ [:every,2,:week],   []                ] ],
      ["tweewekelijks op maandag",      [ [:every,2,:week],   [1]               ] ],
      ["maandag tweewekelijks",         [ [:every,2,:week],   [1]               ] ],
      ["maandag elke maand",            [ [:every,1,:month],  [1]               ] ],
      ["elke maand dinsdag",            [ [:every,1,:month],  [2]               ] ],
      ["elke maand op dinsdag",         [ [:every,1,:month],  [2]               ] ],
      
      ]
          
    run_examples examples    
  end
  
end