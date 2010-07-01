require File.dirname(__FILE__) + '/test_helper.rb'

class MongoWatchableTest < ActiveSupport::TestCase
  
  context "user unwatches non-watching widget with unwatch" do
    setup do
      @user = User.create!(:name => 'foo')
      @widget = Widget.create!(:name => 'bar')
        
      @return = @user.unwatch(@widget)
    end
    
    should "return with false" do
      assert !@return
    end
  end
  
  context "user unwatches non-watching widget with unwatch!" do
    setup do
      @user = User.create!(:name => 'foo')
      @widget = Widget.create!(:name => 'bar')
    end
    
    should "throw standard error" do
      assert_raises RuntimeError do
        @user.unwatch!(@widget)
      end
    end
  end
  
  context "user watching widget with watch" do
    setup do
      @user = User.create!(:name => 'foo')
      @widget = Widget.create!(:name => 'bar')
      
      @return = @user.watch(@widget)
      @user.reload
      @widget.reload
    end
    
    should "only have 1 widget in widget_watchings array" do
      assert_equal 1, @user.widget_watchings.size
    end
    
    should "increment widget_watchings_count" do
      assert_equal 1, @user.widget_watchings_count
    end
    
    should "have widget in widget watchings array" do
      assert_equal @widget, @user.widget_watchings.first
    end
    
    should "have only one watcher in widgets user_watchers array" do
      assert_equal 1, @widget.user_watchers.size
    end
    
    should "increment user_watchers_count" do
      assert_equal 1, @widget.user_watchers_count
    end
    
    should "be the watcher in widgets user_watchers array" do
      assert_equal @user, @widget.user_watchers.first
    end
    
    should "return true for watching?" do
      assert @user.watching?(@widget)
    end
    
    should "return with true" do
      assert @return
    end
    
    context "and then watches widget again" do
      setup do
        @return = @user.watch(@widget)
      end
    
      should "return with false" do
        assert !@return
      end
    end
    
    context "and another widget" do
      setup do
        @widget2 = Widget.create!(:name => 'baz')
        @return = @user.watch(@widget2)
        @user.reload
        @widget2.reload
      end
    
      should "return with true" do
        assert @return
      end
    
      should "only have 2 widgets in widget_watchings array" do
        assert_equal 2, @user.widget_watchings.size
      end
    
      should "increment widget_watchings_count" do
        assert_equal 2, @user.widget_watchings_count
      end
      
      should "have widget in widget watchings array" do
        assert_equal @widget, @user.widget_watchings.first
      end
      
      should "have widget2 in widget watchings array" do
        assert_equal @widget2, @user.widget_watchings.last
      end
    
      should "have only one watcher in widget's user_watchers array" do
        assert_equal 1, @widget.user_watchers.size
      end
    
      should "not increment user_watchers_count" do
        assert_equal 1, @widget.user_watchers_count
      end
      
      should "be the watcher in widget's user_watchers array" do
        assert_equal @user, @widget.user_watchers.first
      end
    
      should "have only one watcher in widget2's user_watchers array" do
        assert_equal 1, @widget2.user_watchers.size
      end
      
      should "be the watcher in widget2's user_watchers array" do
        assert_equal @user, @widget2.user_watchers.first
      end
    end
    
    context "and then unwatched with unwatch" do
      setup do
        @return = @user.unwatch(@widget)
        @user.reload
        @widget.reload
      end
      
      should "have no widgets in widget_watchings array" do
        assert @user.widget_watchings.empty?
      end
      
      should "have no user_watchers in widget" do
        assert @widget.user_watchers.empty?
      end
      
      should "have 0 widget_watchings_count" do
        assert_equal 0, @user.widget_watchings_count
      end
      
      should "have 0 user_watchers_count" do
        assert_equal 0, @widget.user_watchers_count
      end
    
      should "return with true" do
        assert @return
      end
    end
  end
  
  context "user watching widget with watch!" do
    setup do
      @user = User.create!(:name => 'foo')
      @widget = Widget.create!(:name => 'bar')
      
      @user.watch!(@widget)
      @user.reload
      @widget.reload
    end
    
    should "only have 1 widget in widget_watchings array" do
      assert_equal 1, @user.widget_watchings.size
    end
    
    should "increment widget_watchings_count" do
      assert_equal 1, @user.widget_watchings_count
    end
    
    should "have widget in widget watchings array" do
      assert_equal @widget, @user.widget_watchings.first
    end
    
    should "have only one watcher in widgets user_watchers array" do
      assert_equal 1, @widget.user_watchers.size
    end
    
    should "increment user_watchers_count" do
      assert_equal 1, @widget.user_watchers_count
    end
    
    should "be the watcher in widgets user_watchers array" do
      assert_equal @user, @widget.user_watchers.first
    end
    
    should "return true for watching?" do
      assert @user.watching?(@widget)
    end
    
    context "and another widget" do
      setup do
        @widget2 = Widget.create!(:name => 'baz')
        @user.watch!(@widget2)
        @user.reload
        @widget2.reload
      end
    
      should "have 2 widgets in widget_watchings array" do
        assert_equal 2, @user.widget_watchings.size
      end
    
      should "increment widget_watchings_count" do
        assert_equal 2, @user.widget_watchings_count
      end
      
      should "have widget in widget watchings array" do
        assert_equal @widget, @user.widget_watchings.first
      end
      
      should "have widget2 in widget watchings array" do
        assert_equal @widget2, @user.widget_watchings.last
      end
    
      should "have one watcher in widget's user_watchers array" do
        assert_equal 1, @widget.user_watchers.size
      end
    
      should "not increment user_watchers_count" do
        assert_equal 1, @widget.user_watchers_count
      end
      
      should "be the watcher in widget's user_watchers array" do
        assert_equal @user, @widget.user_watchers.first
      end
    
      should "have only one watcher in widget2's user_watchers array" do
        assert_equal 1, @widget2.user_watchers.size
      end
      
      should "be the watcher in widget2's user_watchers array" do
        assert_equal @user, @widget2.user_watchers.first
      end
      
      should "return correct widget with call to all with opts" do
        widgets = @user.widget_watchings.all(:name => @widget.name)
        assert_equal 1, widgets.size
        assert_equal @widget, widgets.first
      end
    end
    
    context "and then watches widget again" do
      should "raise RuntimeError" do
        assert_raises RuntimeError do
          @user.watch!(@widget)
        end
      end
    end
    
    context "and then unwatched with unwatch!" do
      setup do
        @user.unwatch!(@widget)
        @user.reload
        @widget.reload
      end
      
      should "have no widgets in widget_watchings array" do
        assert @user.widget_watchings.empty?
      end
      
      should "have no user_watchers in widget" do
        assert @widget.user_watchers.empty?
      end
      
      should "have 0 widget_watchings_count" do
        assert_equal 0, @user.widget_watchings_count
      end
      
      should "have 0 user_watchers_count" do
        assert_equal 0, @widget.user_watchers_count
      end
    end
  end
  
end