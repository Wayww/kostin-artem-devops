import hudson.security.AuthorizationStrategy
import hudson.security.SecurityRealm
import jenkins.model.Jenkins

def instance = Jenkins.get()
instance.setSecurityRealm(SecurityRealm.NO_AUTHENTICATION)
instance.setAuthorizationStrategy(AuthorizationStrategy.UNSECURED)
instance.setCrumbIssuer(null)
instance.save()
