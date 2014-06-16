def active_record_extended
  ActiveRecord::Base.extend(SeemsRateable::Models::ActiveRecordExtension)
end

def action_view_extended
  ActionView::Base.extend(SeemsRateable::Helpers::ActionViewExtension)
end

class DummyModel < active_record_extended;end

class DummyView < action_view_extended
  def current_rater
    nil
  end
end

ActiveRecord::Migration.verbose = false
ActiveRecord::Migration.create_table(:dummy_models) unless ActiveRecord::Migration.tables.include?("dummy_models")

