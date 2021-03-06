require "rails_helper"

RSpec.describe AgencyMailer, type: :mailer do
  describe 'Job Seeker registered' do
    let!(:agency) { FactoryGirl.create(:agency) }
    let!(:agency_person) { FactoryGirl.create(:agency_person, agency: agency) }
    let!(:job_seeker) { FactoryGirl.create(:job_seeker) }
    let(:mail) { AgencyMailer.job_seeker_registered(agency_person.email,
                                    job_seeker) }

    it "renders the headers" do
      expect(mail.subject).to eq 'Job seeker registered'
      expect(mail.to).to eq(["#{agency_person.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end
    it "renders the body" do
      expect(mail).
          to have_body_text("A new job seeker has joined PETS:")
    end
    it "includes link to show job seeker" do
      expect(mail).
          to have_body_text(/#{job_seeker_url(id: 1)}/)
    end
  end

  describe 'Company registered' do
    let!(:agency) { FactoryGirl.create(:agency) }
    let!(:agency_person) { FactoryGirl.create(:agency_person, agency: agency) }
    let!(:company) { FactoryGirl.create(:company) }
    let(:mail) { AgencyMailer.company_registered(agency_person.email,
                                    company) }

    it "renders the headers" do
      expect(mail.subject).to eq 'Company registered'
      expect(mail.to).to eq(["#{agency_person.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end
    it "renders the body" do
      expect(mail).
          to have_body_text("A company has requested registration in PETS:")
    end
    it "includes link to show company" do
      expect(mail).
          to have_body_text(/#{company_url(id: 1)}/)
    end
  end

  describe 'Job seeker applied to job' do
    let!(:agency_person) { FactoryGirl.create(:agency_admin) }
    let(:job_seeker)     { FactoryGirl.create(:job_seeker) }
    let!(:company) { FactoryGirl.create(:company) }
    let(:company_person) { FactoryGirl.create(:company_person, company: company) }
    let(:job)            { FactoryGirl.create(:job, company: company,
                                              company_person: company_person) }
    let(:application) do
      job.apply job_seeker
      job.last_application_by_job_seeker(job_seeker)
    end

    let(:mail) { AgencyMailer.job_seeker_applied(agency_person.email,
                                    application) }

    it "renders the headers" do
      expect(mail.subject).to eq 'Job seeker applied'
      expect(mail.to).to eq(["#{agency_person.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end
    it "renders the body" do
      expect(mail).to have_body_text("A job seeker has applied to this job:")
    end
    it "includes link to show job" do
      expect(mail).to have_body_text(/#{job_url(id: 1)}/)
    end
    it "includes link to show job seeker" do
      expect(mail).to have_body_text(/#{job_seeker_url(id: 1)}/)
    end
  end

end
