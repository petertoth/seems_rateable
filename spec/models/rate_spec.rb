require 'spec_helper'

describe SeemsRateable::Rate do
  it { should belong_to(:rateable) }
  it { should belong_to(:rater) }
end
