---
name: check-spec
description: "Validate Specification Quality. Use when user says '/architecture:check-spec', wants to review a spec, or needs specification validation."
disable-model-invocation: true
---

# Validate Specification Quality

## Spec File: $ARGUMENTS

Review a feature specification for completeness and implementation readiness.

## Validation Checklist

### Requirements Clarity
- [ ] Feature purpose and goals clearly defined
- [ ] Target users and use cases identified
- [ ] Success criteria measurable and specific
- [ ] Core functionality well-described

### User Experience
- [ ] User stories cover main workflows
- [ ] Edge cases and error states considered
- [ ] UI requirements specified
- [ ] Accessibility considerations included

### Technical Specifications
- [ ] Data requirements defined
- [ ] Integration points identified
- [ ] Performance requirements specified
- [ ] Security needs addressed

### Implementation Readiness
- [ ] Acceptance criteria are testable
- [ ] Technical constraints documented
- [ ] Dependencies noted
- [ ] Out-of-scope items defined

## Quality Score (1-10)

- **1-3**: Major gaps, needs significant work
- **4-6**: Good foundation, some areas need clarification
- **7-8**: Well-defined, minor improvements possible
- **9-10**: Comprehensive and implementation-ready

## Feedback Report

- **Strengths**: What the spec does well
- **Missing Elements**: Critical gaps to address
- **Clarification Needed**: Vague or ambiguous areas
- **Suggestions**: Ways to improve
- **Risk Assessment**: Potential challenges

## Recommended Actions

- **Ready to implement**: Proceed with implementation
- **Needs revision**: Specific areas to improve first
- **Requires research**: External factors to investigate
- **Scope adjustment**: MVP vs full feature recommendations
