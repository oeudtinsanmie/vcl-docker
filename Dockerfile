FROM centos:centos6

RUN curl -sSL https://get.rvm.io | bash -s stable --ruby
RUN rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
RUN yum install -y puppet-server ruby-devel
RUN gem install librarian-puppet puppet

ADD Puppetfile /etc/puppet/Puppetfile
ADD manifests/vclnode.pp /etc/puppet/manifests/vclnode.pp
ADD manifests/hostnode.pp /etc/puppet/manifests/hostnode.pp
ADD hiera/vclnode.yaml /etc/puppet/hiera/nodes/vclnode.yaml
ADD hiera/hostnode.yaml /etc/puppet/hiera/nodes/hostnode.yaml

RUN cd /etc/puppet;librarian-puppet init;librarian-puppet install --clean
RUN cd /etc/puppet;puppet apply --debug manifests --modulepath /etc/puppet/modules

