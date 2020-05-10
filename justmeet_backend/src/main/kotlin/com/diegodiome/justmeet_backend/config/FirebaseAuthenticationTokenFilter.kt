package com.diegodiome.justmeet_backend.config

import com.diegodiome.justmeet_backend.config.constants.SecurityConstants.TOKEN_HEADER
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseAuthException
import com.google.firebase.auth.FirebaseToken
import org.slf4j.LoggerFactory
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.filter.OncePerRequestFilter
import java.lang.Exception
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class FirebaseAuthenticationTokenFilter : OncePerRequestFilter() {

    private var firebaseAuthTokenFilterLogger = LoggerFactory.getLogger(FirebaseAuthenticationTokenFilter::class.java)

    override fun doFilterInternal(request: HttpServletRequest, response: HttpServletResponse, filterChain: FilterChain) {
        firebaseAuthTokenFilterLogger.info("Authenticating...")

        val authToken = request.getHeader(TOKEN_HEADER)

        if(authToken.isNullOrEmpty()) {
            filterChain.doFilter(request, response)
            firebaseAuthTokenFilterLogger.warn("Null token")
            return
        }

        try {
            val authentication = getAndValidateAuthentication(authToken)
            SecurityContextHolder.getContext().authentication = authentication
            firebaseAuthTokenFilterLogger.info("Successfully authenticated")
        } catch (ex: Exception) {
            response.status = HttpServletResponse.SC_UNAUTHORIZED
            firebaseAuthTokenFilterLogger.info("Error : ", ex)
        }
        filterChain.doFilter(request, response)
    }

    private fun getAndValidateAuthentication(authToken: String) : Authentication{
        val firebaseToken = authenticateFirebaseToken(authToken)
        return UsernamePasswordAuthenticationToken(firebaseToken, authToken, ArrayList())
    }

    private fun authenticateFirebaseToken(authToken: String) : FirebaseToken{
        val app = FirebaseAuth.getInstance().verifyIdTokenAsync(authToken)
        return app.get()
    }

    override fun destroy() {
        firebaseAuthTokenFilterLogger.info("Destroy filter")
    }
}