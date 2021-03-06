require 'cfn-nag/violation'
require_relative 'base'

class IamManagedPolicyNotResourceRule < BaseRule

  def rule_text
    'IAM managed policy should not allow Allow+NotResource'
  end

  def rule_type
    Violation::WARNING
  end

  def rule_id
    'W23'
  end

  def audit_impl(cfn_model)
    violating_policies = cfn_model.resources_by_type('AWS::IAM::ManagedPolicy').select do |policy|
      !policy.policyDocument.allows_not_resource.empty?
    end

    violating_policies.map { |policy| policy.logical_resource_id }
  end
end
