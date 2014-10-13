FROM centos:centos6

RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum install -y puppet-server ruby-devel
RUN gem install librarian-puppet
ADD Puppetfile /etc/puppet/Puppetfile

