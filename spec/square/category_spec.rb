require 'spec_helper'

describe Square::Category do
  subject { Square::Category }
  it_behaves_like 'a listable resource'
  it_behaves_like 'a creatable resource'
  it_behaves_like 'an updatable resource'
  it_behaves_like 'a deletable resource'
end
